" Better navigation: the current line is always at middle of the screen
nnoremap k kzz
nnoremap j jzz
nnoremap p pzz
nnoremap P Pzz
nnoremap G Gzz
nnoremap x xzz
nnoremap <PageUp> <PageUp>zz
nnoremap <PageDown> <PageDown>zz

" Continuous visual shifting (does not exit Visual mode), `gv` means
" to reselect previous visual area, see https://superuser.com/q/310417/736190
xnoremap < <gv
xnoremap > >gv

" When completion menu is shown, use <cr> to select an item and do not add an
" annoying newline. Otherwise, <enter> is what it is. For more info , see
" https://superuser.com/a/941082/736190 and
" https://unix.stackexchange.com/q/162528/221410
" inoremap <expr> <cr> ((pumvisible())?("\<C-Y>"):("\<cr>"))
" Use <esc> to close auto-completion menu
" inoremap <expr> <esc> ((pumvisible())?("\<C-e>"):("\<esc>"))

" Tab-complete, see https://vi.stackexchange.com/q/19675/15292.
inoremap <expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" Edit and reload nvim config file quickly
nnoremap <silent> <leader>ev :<C-U>tabnew $MYVIMRC <bar> tcd %:h<cr>
nnoremap <silent> <leader>sv :<C-U>silent update $MYVIMRC <bar> source $MYVIMRC <bar>
      \ call v:lua.vim.notify("Nvim config successfully reloaded!", 'info', {'title': 'nvim-config'})<cr>

" Show all todos inside a telescope
nnoremap <silent> <leader>tv :TodoTelescope<cr>
" Toggle terminal
nnoremap <silent> <leader>tt :call v:lua.require("config.term").term_toggle()<cr>

" Toggle git client
nnoremap <silent> <leader>gv :call v:lua.require("config.term").git_client_toggle()<cr>

" Patching gx in order to open URLs without netrw
nmap <silent>gx :sil !open <cWORD><CR>

" Use Esc to quit builtin terminal
tnoremap <ESC>   <C-\><C-n>

" Better split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nmap <silent> <leader>bk :bd<CR>
nmap <silent> <leader>op :NvimTreeToggle<CR>

" Move current line up and down
nnoremap <silent> <A-k> <Cmd>call utils#SwitchLine(line('.'), 'up')<CR>
nnoremap <silent> <A-j> <Cmd>call utils#SwitchLine(line('.'), 'down')<CR>

" Move current visual-line selection up and down
xnoremap <silent> <A-k> :<C-U>call utils#MoveSelection('up')<CR>
xnoremap <silent> <A-j> :<C-U>call utils#MoveSelection('down')<CR>

" Keep cursor position after yanking
nnoremap y myy
xnoremap y myy

augroup restore_after_yank
  autocmd!
  autocmd TextYankPost *  call s:restore_cursor()
augroup END

function! s:restore_cursor() abort
  silent! normal `y
  silent! delmarks y
endfunction
