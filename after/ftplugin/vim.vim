" Disable inserting comment leader after hitting o or O or <Enter>
set formatoptions-=o
set formatoptions-=r

" Use :help command for keyword when pressing `K` in vim file,
" see `:h K` and https://stackoverflow.com/q/15867323/6064933
set keywordprg=:help

set tabstop=2       " number of visual spaces per TAB
set softtabstop=2   " number of spaces in tab when editing
set shiftwidth=2    " number of spaces to use for autoindent
set expandtab       " expand tab to spaces so that tabs are spaces

nnoremap <silent> <F9> :source %<CR>

