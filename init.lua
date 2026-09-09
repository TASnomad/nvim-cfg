vim.loader.enable()

local version = vim.version

-- Allowing all versions 0.12.x
local expected_ver = version.range("0.12")
---@cast expected_ver vim.VersionRange
local current_ver = version()
local result_ver = expected_ver:has(current_ver)

if result_ver == false then
    local _v = string.format("%s.%s.%s", current_ver.major, current_ver.minor, current_ver.patch)
    local msg = string.format("Expect nvim v[from '%s' - to: '%s'], but got %s instead. You're on your own!",
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
    vim.schedule(function()
        vim.opt.clipboard = "unnamedplus"
    end)
end

local core_conf_files = {
    "globals.lua",
    "options.lua",
    "autocommands.lua",
    "usercommands.lua",
    "mappings.lua",
    "lazy_setup.lua",
    "abbrevs.lua",
}

for _, f in ipairs(core_conf_files) do
    local m, _ = string.gsub(f, "%.lua", "")
    package.loaded[m] = nil
    require(m)
end
