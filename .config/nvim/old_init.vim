" Automatic file type detection and indentation scripts
filetype plugin indent on

set secure

" Try the following EOL styles when editing new buffers,
" use Unix style by default
set fileformats=unix,dos,mac fileformat=unix

set nolist
set listchars=tab:\ \ ,trail:.

" Hex editing
" ex command for toggling hex mode - define mapping if desired
command! -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function! ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

nnoremap <A-h> :Hexmode<CR>
inoremap <A-h> <Esc>:Hexmode<CR>
vnoremap <A-h> :<C-U>Hexmode<CR>

" Automatically hex edit binary files
" vim -b : edit binary using xxd-format!
augroup Binary
au!

" set binary option for all binary files before reading them
au BufReadPre *.bin,*.hex setlocal binary

" if on a fresh read the buffer variable is already set, it's wrong
au BufReadPost *
        \ if exists('b:editHex') && b:editHex |
        \   let b:editHex = 0 |
        \ endif

" convert to hex on startup for binary files automatically
au BufReadPost *
        \ if &binary | Hexmode | endif

" When the text is freed, the next time the buffer is made active it will
" re-read the text and thus not match the correct mode, we will need to
" convert it again if the buffer is again loaded.
au BufUnload *
        \ if getbufvar(expand("<afile>"), 'editHex') == 1 |
        \   call setbufvar(expand("<afile>"), 'editHex', 0) |
        \ endif

" before writing a file when editing in hex mode, convert back to non-hex
au BufWritePre *
        \ if exists("b:editHex") && b:editHex && &binary |
        \  let oldro=&ro | let &ro=0 |
        \  let oldma=&ma | let &ma=1 |
        \  silent exe "%!xxd -r" |
        \  let &ma=oldma | let &ro=oldro |
        \  unlet oldma | unlet oldro |
        \ endif

" after writing a binary file, if we're in hex mode, restore hex mode
au BufWritePost *
        \ if exists("b:editHex") && b:editHex && &binary |
        \  let oldro=&ro | let &ro=0 |
        \  let oldma=&ma | let &ma=1 |
        \  silent exe "%!xxd" |
        \  exe "set nomod" |
        \  let &ma=oldma | let &ro=oldro |
        \  unlet oldma | unlet oldro |
        \ endif
augroup END

" Language specific settings
autocmd FileType haskell setl expandtab nofoldenable
autocmd FileType haskell inoremap <leader>{o {-# OPTIONS  #-}<ESC>3hi
autocmd FileType haskell inoremap <leader>{l {-# LANGUAGE  #-}<ESC>3hi

" ========================================
" Plugins
" ========================================
" NERDTree
nnoremap <silent> <C-t> :NERDTreeToggle<CR>
nnoremap <silent> <F3> :if exists('b:NERDTree') <bar>
              \     NERDTreeToggle <bar>
              \ else <bar>
              \     NERDTreeFind <bar>
              \ endif<CR>
let g:NERDTreeIgnore = ['\.vim$', '\~$', '\.git$', '\.pyc$']

" Use the Silver Searcher instead of Ack
let g:ackprg='ag --nogroup --nocolor --column'
nnoremap <leader>a :Ack!<Space>

" Markdown plugin
" Disable folding
let g:vim_markdown_folding_disabled = 1

" Estimate talk time at 130 words per minute.
" Source: https://hillelwayne.com/post/talk-fast/
function! g:Exo_vwal()
  let s:worddict = wordcount()
  if has_key(s:worddict, 'visual_words')
    return s:worddict['visual_words']
  else
    return s:worddict['words']
  endif
endfunction

command! -nargs=* Pi term pi <args>
command! -nargs=0 Py term python3
command! -nargs=0 R term R --quiet --no-save
" Automatically enter terminal mode upon starting a terminal.
autocmd TermOpen * startinsert

" Macros management procedures by Hillel Wayne.
" Source: https://buttondown.email/hillelwayne/archive/language-warts-and-vim-trix/
let s:macro_file = $HOME . "/.config/nvim/macros.json"

function! s:macro_list(ArgLead, CmdLine, CursorPos)
  let macros = json_decode(readfile(s:macro_file))
  return join(keys(macros), "\n")
endfunction

function! s:GetMacro(macro_name)
  let macros = json_decode(readfile(s:macro_file))
  echom macros[a:macro_name]
endfunction

command! -nargs=1 -complete=custom,s:macro_list GetMacro call s:GetMacro(<f-args>)

function! s:SetMacro(macro_name, reg)
  let macros = json_decode(readfile(s:macro_file))
  call setreg(a:reg, macros[a:macro_name])
endfunction

command! -nargs=+ SetMacro call s:SetMacro(<f-args>)

function! s:SaveMacro(macro_name, reg)
  let macros = json_decode(readfile(s:macro_file))
  let macros[a:macro_name] = getreg(a:reg)
  call writefile([json_encode(macros)], s:macro_file)
endfunction

command! -nargs=+ SaveMacro call s:SaveMacro(<f-args>)

function! s:MdFootnote(note)
  let s:footnote = "[^".a:note."]"
  let @m = s:footnote
  norm "mpmm
  $put = s:footnote.':'
  norm `m
endfunction

augroup project
    autocmd VimEnter * highlight clear SignColumn

    autocmd FileType python setlocal commentstring=#\ %s
    autocmd FileType gitcommit setlocal spell textwidth=72
    autocmd FileType c,cpp setlocal equalprg=clang-format

    autocmd BufRead,BufNewFile *.h,*.c
        \ set filetype=c.doxygen
    autocmd BufRead,BufNewFile Dockerfile*,Containerfile*
        \ set filetype=dockerfile
augroup END

autocmd BufRead *.wsgi set filetype=python

nnoremap <LocalLeader>n :cnext<cr>

" Use the PostgreSQL highlighter by default for SQL files
" https://github.com/lifepillar/pgsql.vim
let g:sql_type_default="pgsql"

" Enable all Python syntax enhancements
" https://github.com/vim-python/python-syntax
let g:python_highlight_all=1
