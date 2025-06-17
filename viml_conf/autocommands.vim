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

lua require("autocommands")
