let g:is_win = (has('win32') || has('win64')) ? v:true : v:false
let g:is_linux = (has('unix') && !has('macunix')) ? v:true : v:false
let g:is_mac = has('macunix') ? v:true : v:false
let g:logging_level = 'info'


" Disable perl provider
let g:loaded_perl_provider = 0

" Disable ruby provider
let g:loaded_ruby_provider = 0

" Disable node provider
let g:loaded_node_provider = 0

let g:did_install_default_menus = 1  " do not load menu

" Removing any remap for the spacebar before declaring it as mapleader
nnoremap <SPACE> <Nop>

" Custom mapping <leader>, spacebar used
let g:mapleader = " "

" Enable highlighting for lua HERE doc inside vim script
let g:vimsyn_embed = "1"

" Use English as main language
" TODO: we should find a workaround for mac os
if !g:is_mac
  language en_US.utf-8
endif

" use filetype.lua instead of filetype.vim
let g:do_filetype_lua = 1
let g:did_load_filetypes = 0

" disabling netrw
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1
let g:netrw_liststyle = 3
if g:is_win
  let g:netrw_http_cmd = 'curl --ssl-no-revoke -Lo'
endif

" Do not load zipPlugin.vim, gzip.vim and tarPlugin.vim (all these plugins are
" related to checking files inside compressed files)
let g:loaded_zipPlugin = 1
let loaded_gzip = 1
let g:loaded_tarPlugin = 1

let g:loaded_tutor_mode_plugin = 1  " do not load the tutor plugin

" Do not use builtin matchit.vim and matchparen.vim since we use vim-matchup
let g:loaded_matchit = 1

" Disable sql omni completion, it is broken.
let g:loaded_sql_completion = 1
