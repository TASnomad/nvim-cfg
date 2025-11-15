" Custom fold
" credits to https://essais.co/better-folding-in-neovim/

function! IdentLevel(lnum)
  return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
  let nlines = lines('$')
  let current = a:lnum + 1

  while current <= nlines
    if getline(current) =~? '\v\S'
      return current
    endif

    let current += 1
  endwhile

  return -2
endfunction

function! GetFoldPosition(lnum)
  if getline(a:lnum) =~? '\v^\s*$'
    return '-1'
  endif

  let currentIndent = IdentLevel(a:lnum)
  let nextIndent = IdentLevel(NextNonBlankLine(a:lnum))

  if nextIndent == currentIndent
    return currentIndent
  elseif nextIndent < currentIndent
    return currentIndent
  elseif nextIndent > currentIndent
    return '>' . nextIndent
  endif
endfunction

function! CustomFoldText()
  let fs = v:foldstart

  while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
  endwhile

  if fs > v:foldend
    let line = getline(v:foldstart)
  else
    let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
  let foldsize = 1 + v:foldend - v:foldstart
  let foldTlDrStr = " " . foldsize . " lines "
  let foldLevelStr = repeat("+--", v:foldlevel)
  let expansionStr = repeat(" ", w - strwidth(foldTlDrStr.line.foldLevelStr))

  return line . expansionStr . foldTlDrStr . foldLevelStr
endfunction
