local fn = vim.fn

local M = {}

local function single_quote(str)
  return "'" .. str:gsub("'", "''") .. "'"
end

function M.cabbrev(key, value)
  vim.cmd(string.format(
    "cabbrev <expr> %s (getcmdtype() == ':' && getcmdpos() <= %d) ? %s : %s",
    key, 1 + #key, single_quote(value), single_quote(key)
  ))
end

function M.switch_line(src_line_idx, direction)
  if direction == "up" then
    if src_line_idx == 1 then return end
    vim.cmd("move-2")
  elseif direction == "down" then
    if src_line_idx == vim.fn.line("$") then return end
    vim.cmd("move+1")
  end
end

function M.move_selection(direction)
  -- Only act if the previous mode was visual line mode (V).
  -- Since we've left visual mode by the time this runs, mode() returns 'n',
  -- so we use visualmode() to check what the last visual mode was.
  -- See https://stackoverflow.com/a/61486601/6064933
  if vim.fn.visualmode() ~= "V" then return end

  local start_line = vim.fn.line("'<")
  local end_line   = vim.fn.line("'>")
  local num_lines  = end_line - start_line + 1

  if direction == "up" then
    if start_line == 1 then
      vim.cmd("normal! gv")
      return
    end
    vim.cmd(string.format("silent %s,%smove-2", start_line, end_line))
    vim.cmd("normal! gv")
  elseif direction == "down" then
    if end_line == vim.fn.line("$") then
      vim.cmd("normal! gv")
      return
    end
    vim.cmd(string.format("silent %s,%smove+%s", start_line, end_line, num_lines))
    vim.cmd("normal! gv")
  end
end

function M.get_titlestr()
  local title_str = ""

  if vim.g.is_linux then
    title_str = vim.fn.hostname() .. "  "
  end

  local buf_path = vim.fn.expand("%:p:~")
  title_str = title_str .. buf_path .. "  "

  if vim.bo.buflisted and buf_path ~= "" then
    local ftime = vim.fn.getftime(vim.fn.expand("%"))
    title_str = title_str .. vim.fn.strftime("%Y-%m-%d %H:%M:%S%z", ftime)
  end

  return title_str
end

function M.executable(name)
  if fn.executable(name) > 0 then
    return true
  end

  return false
end

--- check whether a feature exists in Nvim
--- @feat: string
---   the feature name, like `nvim-0.7` or `unix`.
--- return: bool
M.has = function(feat)
  if fn.has(feat) == 1 then
    return true
  end

  return false
end

--- Create a dir if it does not exist
function M.may_create_dir(dir)
  local res = fn.isdirectory(dir)

  if res == 0 then
    fn.mkdir(dir, "p")
  end
end

--- Generate random integers in the range [Low, High], inclusive,
--- adapted from https://stackoverflow.com/a/12739441/6064933
--- @low: the lower value for this range
--- @high: the upper value for this range
function M.rand_int(low, high)
  -- Use lua to generate random int, see also: https://stackoverflow.com/a/20157671/6064933
  math.randomseed(os.time())

  return math.random(low, high)
end

-- TODO: not used, should be removed
--- Select a random element from a sequence/list.
--- @seq: the sequence to choose an element
function M.rand_element(seq)
  local idx = M.rand_int(1, #seq)

  return seq[idx]
end

-- TODO: not used, should be removed
function M.add_pack(name)
  local status, error = pcall(vim.cmd, "packadd " .. name)

  return status
end

return M
