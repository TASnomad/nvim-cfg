vim.loader.enable()

local version = vim.version

-- Allowing all 0.11.x versions
local expected_ver = version.range("^0.11")
local current_ver = version()

---@diagnostic disable-next-line: need-check-nil, invisible
local result_ver = expected_ver:has(current_ver)

if result_ver == false then
  local _v = string.format("%s.%s.%s", current_ver.major, current_ver.minor, current_ver.patch)
  local msg = string.format("Expect nvim v[from '%s' - to: '%s'], but got %s instead. You're on your own!",
    ---@diagnostic disable-next-line: need-check-nil
    expected_ver.from, expected_ver.to, _v)
  vim.api.nvim_echo({ { msg } }, true, { err = true })
end

--  Config specific to neovide
if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font Mono:h14"
  vim.g.neovide_opacity = 1.0
  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_cursor_trail_size = 0.3
  vim.g.neovide_cursor_vfx_mode = ""
  vim.g.neovide_cursor_vfx_particle_density = 10.0
  vim.g.neovide_cursor_vfx_opacity = 150.0
  if vim.g.is_mac then
    vim.g.neovide_input_use_logo = 1
  end
end

local core_conf_files = {
  "globals.lua",
  "options.lua",
  "autocommands.vim",
  "mappings.lua",
  "plugins.vim",
}

local vim_conf_dir = vim.fn.stdpath("config") .. "/viml_conf"
for _, f in ipairs(core_conf_files) do
  if vim.endswith(f, "vim") then
    local p = string.format("%s/%s", vim_conf_dir, f)
    local cmd = "source " .. p
    vim.cmd(cmd)
  else
    local m, _ = string.gsub(f, "%.lua", "")
    package.loaded[m] = nil
    require(m)
  end
end
