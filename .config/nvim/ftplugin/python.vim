" Global flake8 config is located in ~/.config/flake8
" NOTE(2022-02-14): flake8 removed for now
let b:ale_linters = ['mypy', 'pylint']

" Various snippets.
" nnoremap <leader>ifmain iif __name__ == '__main__':<CR>pass<CR>else:<CR>raise NotImplementedError<Esc>2k
nnoremap <leader>ifmain iif __name__ == "__main__":<CR>
