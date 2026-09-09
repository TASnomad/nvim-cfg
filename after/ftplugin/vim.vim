" Disable inserting comment leader after hitting o or O or <Enter>
setlocal formatoptions-=o
setlocal formatoptions-=r

" Use :help command for keyword when pressing `K` in vim file,
" see `:h K` and https://stackoverflow.com/q/15867323/6064933
setlocal keywordprg=:help

setlocal tabstop=2       " number of visual spaces per TAB
setlocal softtabstop=2   " number of spaces in tab when editing
setlocal shiftwidth=2    " number of spaces to use for autoindent
setlocal expandtab       " expand tab to spaces so that tabs are spaces

nnoremap <buffer> <silent> <F9> :source %<CR>
