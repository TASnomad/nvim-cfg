set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

" Format on save
autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
