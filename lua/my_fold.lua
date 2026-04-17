-- Custom fold
-- credits to https://essais.co/better-folding-in-neovim/

local exports = {}

function exports.indent_level(lnum)
  return vim.fn.indent(lnum) / vim.bo.shiftwidth
end

function exports.next_non_blank_line(lnum)
  local nlines = vim.fn.line("$")
  local current = lnum + 1

  while current <= nlines do
    if vim.fn.getline(current):match("%S") then
      return current
    end
    current = current + 1
  end

  return -2
end

function exports.get_fold_position(lnum)
  if vim.fn.getline(lnum):match("^%s*$") then
    return "-1"
  end

  local current_indent = exports.indent_level(lnum)
  local next_indent    = exports.indent_level(exports.next_non_blank_line(lnum))

  if next_indent > current_indent then
    return ">" .. next_indent
  else
    return current_indent
  end
end

function exports.custom_fold_text()
  local fs = vim.v.foldstart

  while vim.fn.getline(fs):match("^%s*$") do
    fs = vim.fn.nextnonblank(fs + 1)
  end

  local line
  if fs > vim.v.foldend then
    line = vim.fn.getline(vim.v.foldstart)
  else
    line = vim.fn.getline(fs):gsub("\t", string.rep(" ", vim.bo.tabstop))
  end

  local w           = vim.fn.winwidth(0) - vim.wo.foldcolumn - (vim.wo.number and 8 or 0)
  local foldsize    = 1 + vim.v.foldend - vim.v.foldstart
  local fold_tl_str = " " .. foldsize .. " lines "
  local fold_lv_str = string.rep("+--", vim.v.foldlevel)
  local expansion   = string.rep(" ", w - vim.fn.strwidth(fold_tl_str .. line .. fold_lv_str))

  return line .. expansion .. fold_tl_str .. fold_lv_str
end

return exports
