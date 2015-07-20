" Better plugin management
execute pathogen#infect()
" Automatic file type detection and indentation scripts
filetype plugin indent on

" UTF-8 witout BOM as the default file encoding
set encoding=utf-8 nobomb
" Output more characters for redrawing
set ttyfast " Removed in Neovim, always set
" Try the following EOL styles when editing new buffers,
" use Unix style by default
set fileformats=unix,dos,mac fileformat=unix

" Set up default syntax highlighting
syntax on
" Colour scheme
set background=light
colorscheme Tomorrow
" 256 colours in terminal
set t_Co=256

" Modifier for some shortcuts
let mapleader=','

" Don't use swap or backup files
set noswapfile nobackup
" Enable hidden buffers
set hidden
" Modern escapes in regular expressions
set magic
" Automatically detect case-(in)sensitiveness when matching
set ignorecase smartcase
" Incremental search and higlighting
set incsearch hlsearch
" Use spaces by default
set expandtab
" Four-space tabs
set shiftwidth=4 tabstop=4 softtabstop=4
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
" More frequent redraws
set redrawtime=200

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

set history=1000
set undolevels=1000
set title
set visualbell noerrorbells
" Don't redraw while executing macros
set lazyredraw

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
nnoremap <C-h>   <C-w>h
nnoremap <C-j>   <C-w>j
nnoremap <C-k>   <C-w>k
nnoremap <C-l>   <C-w>l
" Moving lines up and down
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
"let g:airline_theme='bubblegum'
let g:airline_theme='sol'
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

" Use the Silver Searcher instead of Ack if available
system('ag --version')
if v:shell_error == 0
	let g:ackprg='ag --nogroup --nocolor --column'
endif

