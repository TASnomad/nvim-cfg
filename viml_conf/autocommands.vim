" Do not use smart case in command line mode, extracted from https://vi.stackexchange.com/a/16511/15292.
augroup dynamic_smartcase
  autocmd!
  autocmd CmdLineEnter : set nosmartcase
  autocmd CmdLineLeave : set smartcase
augroup END

augroup term_settings
  autocmd!
  " Do not use number and relative number for terminal inside nvim
  autocmd TermOpen * setlocal norelativenumber nonumber
  " Go to insert mode by default to start typing command
  autocmd TermOpen * startinsert
augroup END

" More accurate syntax highlighting? (see `:h syn-sync`)
augroup accurate_syn_highlight
  autocmd!
  autocmd BufEnter * :syntax sync fromstart
augroup END

" Return to last cursor position when opening a file
augroup resume_cursor_position
  autocmd!
  autocmd BufReadPost * call s:resume_cursor_position()
augroup END

" Only resume last cursor position when there is no go-to-line command (something like '+23').
function s:resume_cursor_position() abort
  if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    let l:args = v:argv  " command line arguments
    for l:cur_arg in l:args
      " Check if a go-to-line command is given.
      let idx = match(l:cur_arg, '\v^\+(\d){1,}$')
      if idx != -1
        return
      endif
    endfor

    execute "normal! g`\"zvzz"
  endif
endfunction

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
augroup END

" Define or override some highlight groups
augroup custom_highlight
  autocmd!
  autocmd ColorScheme * call s:custom_highlight()
augroup END

function! s:custom_highlight() abort
	" For yank highlight
	highlight YankColor ctermfg=59 ctermbg=41 guifg=#34495E guibg=#2ECC71

	" For cursor colors
	highlight Cursor cterm=bold gui=bold guibg=#00c918 guifg=black
	highlight Cursor2 guifg=red guibg=red

	" For floating windows border highlight
	highlight FloatBorder guifg=LightGreen guibg=NONE

	" highlight for matching parentheses
	highlight MatchParen cterm=bold,underline gui=bold,underline
endfunction

" solution from: https://vi.stackexchange.com/a/169/15292
function! s:handle_large_file() abort
	let g:large_file = 10485760 "10MB
	let f = expand("<afile>")

	if getfsize(f) > g:large_file || getfsize(f) == -2
		set eventignore+=all
		" turning off relative number helps a lot
		set norelativenumber
		setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1
	else
		set eventignore-=all relativenumber
	endif
endfunction

augroup LargeFile
	autocmd!
	autocmd BufReadPre * call s:handle_large_file()
augroup END

lua require("custom-autocmd")
