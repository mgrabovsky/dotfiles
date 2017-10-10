" Better (some) plugin management
execute pathogen#infect()
" Automatic file type detection and indentation scripts
filetype plugin indent on

" UTF-8 witout byte order mark as the default file encoding
set encoding=utf-8 nobomb
" Output more characters to the screen for smoother UX
set ttyfast " Removed in Neovim, always set
" More frequent redraws
set redrawtime=200
" Try the following EOL styles when editing new buffers,
" use Unix style by default
set fileformats=unix,dos,mac fileformat=unix

" Syntax higlighting on by default
syntax on
" Colour scheme
set background=light
colorscheme Tomorrow
" 256 colours in terminal
set t_Co=256

" Modifier for some shortcuts
let mapleader=','
let maplocalleader='\'

" Don't use swap or backup files
set noswapfile nobackup
" Enable hidden buffers
set hidden
" Modern escapes in regular expressions
set magic
" Automatically detect case sensitivity when matching
set ignorecase smartcase
" Incremental search and higlighting
set incsearch hlsearch
set ignorecase smartcase
" Use spaces by default
set expandtab
" Four-space tabs
set tabstop=4 shiftwidth=4 softtabstop=4
" Round indents to multiples of 'shiftwidth'
set shiftround
set smarttab
set autoindent copyindent
set backspace=indent,eol,start
set formatoptions=crq1j
" Leave at least 4 lines at the top or bottom when scrolling
set scrolloff=4
" Automatically reload changed files
set autoread
" Not word delimiters
set iskeyword+=_,$,%,#

set textwidth=85
set wrap
set whichwrap+=h,l
"set colorcolumn=+0
set showmode
set showcmd
" Enhanced command line
set wildmenu
set wildmode=full
set wildchar=<Tab> wildcharm=<Tab>
set wildignore+=.git,*.exe,*.jpg,*.jpeg,*.bmp,*.png,*.swp,*.bak,*pyc,*.class,*.o,*.hi
set nocursorline
set nonumber relativenumber
set ruler
set laststatus=2
set shortmess=aOtT
set complete=.,w,b,t,i
" Don't put two spaces after ., ! and ? when formatting with gq, J, etc.
set nojoinspaces

set history=1000
set undolevels=1000
set title
set visualbell noerrorbells
" Don't redraw while executing macros
set lazyredraw
" Disable mouse in terminal
set mouse=

set nolist
set listchars=tab:\ \ ,trail:.

" Unmap annoying keys
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
vnoremap <left> <nop>
vnoremap <right> <nop>
vnoremap <up> <nop>
vnoremap <down> <nop>
" Move blockwise using j & k
nnoremap j gj
nnoremap k gk

" One key less
nnoremap ; :
" Switching between buffers
nnoremap <right> :bn<CR>
nnoremap <left>  :bp<CR>
" Switch to the previously edited buffer
nmap <C-e> :b#<CR>
" Closing buffers
nnoremap <leader>bc :bd!<CR>
" Switching between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Moving lines and blocks up and down
nnoremap <A-j> mz:m+<CR>`z
nnoremap <A-k> mz:m-2<CR>`z
vnoremap <A-j> :m'>+<CR>`<my`>mzgv`yo`z
vnoremap <A-k> :m'<-2<CR>`>my`<mzgv`yo`z
" Clear lastest match highlight
nnoremap <leader>/ :let @/=''<CR>
" Vimux shortcuts
nnoremap <leader>vp :VimuxPromptCommand<CR>
nnoremap <leader>vm :VimuxPromptCommand("make ")<CR>
nnoremap <leader>vl :VimuxRunLastCommand<CR>

" Strip all trailing whitespace
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Automatically relaod .vimrc after editing
autocmd! BufWritePost $MYVIMRC source $MYVIMRC

" X11 clipboard
" vim.wikia.com/wiki/Accessing_the_system_clipboard
function! X11Clipboard()
	call system('xclip -selection c', @r)
endfunction
vnoremap <F9>"ry:call X11Clipboard()<CR>

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
if has("autocmd")
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
endif

" Language specific settings
autocmd FileType haskell setl expandtab nofoldenable
autocmd FileType haskell inoremap <leader>{o {-# OPTIONS  #-}<ESC>3hi
autocmd FileType haskell inoremap <leader>{l {-# LANGUAGE  #-}<ESC>3hi

" ========================================
" Plugins
" ========================================
" NERDTree
nnoremap <F3> :NERDTreeToggle<CR>
" CtrlP
nnoremap <leader>bb :CtrlPBuffer<CR>
nnoremap <leader>bm :CtrlPMixed<CR>
nnoremap <leader>b :CtrlPMRU<CR>
" hs2vim
let g:haskell_conceal           = 0
let g:haskell_folds             = 0
let g:haskell_quasi             = 0
let g:haskell_interpolation     = 0
let g:haskell_regex             = 0
let g:haskell_jmacro            = 0
let g:haskell_shqq              = 0
let g:haskell_sql               = 0
let g:haskell_json              = 0
let g:haskell_xml               = 0
let g:haskell_hsp               = 0
let g:haskell_cpp               = 0
let g:haskell_haddock           = 1
let g:haskell_multiline_strings = 1
" Airline
let g:airline_theme='distinguished'
let g:airline#extensions#whitespace#enabled=0
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
" Unicode symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.linenr = ''
let g:airline_symbols.modified = '+'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.space = ' '
let g:airline_symbols.whitespace = 'Ξ'

let g:airline_mode_map = {
	\ '__' : '---',
	\ 'n'  : ' N ',
	\ 'i'  : ' I ',
	\ 'R'  : ' R ',
	\ 'c'  : ' C ',
	\ 'v'  : ' V ',
	\ 'V'  : 'V·L',
	\ '' : 'V·B',
	\ 's'  : ' S ',
	\ 'S'  : 'S·L',
	\ '' : 'S·B',
	\ }

" YouCompleteMe settings
let g:ycm_key_list_select_completion = ['<TAB>']
let g:ycm_key_list_previous_completion = ['<C-p>']
let g:ycm_key_invoke_completion = '<C-n>'
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" Use the Silver Searcher instead of Ack
let g:ackprg='ag --nogroup --nocolor --column'

" ========================================
" Neovim terminal mode
" ========================================
tnoremap <Esc> <C-\><C-n>

" ========================================
" Vim Polyglot
" ========================================
let g:polyglot_disabled = [ 'haskell' ]

" ========================================
" Syntastic
" ========================================
map <Leader>s :SyntasticToggleMode<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" ========================================
" ghc-mod
" ========================================
map <silent> tw :GhcModTypeInsert<CR>
map <silent> ts :GhcModSplitFunCase<CR>
map <silent> tq :GhcModType<CR>
map <silent> te :GhcModTypeClear<CR>

