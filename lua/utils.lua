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

function M.multi_edit(patterns)
  for _, pattern in ipairs(patterns) do
    local files = fn.glob(pattern, false, true)
    for _, file in ipairs(files) do
      vim.cmd("edit " .. file)
    end
  end
end

function M.iso_time(timestamp)
  return os.date("%Y-%m-%d %H:%M:%S%z", timestamp or os.time())
end

return M
