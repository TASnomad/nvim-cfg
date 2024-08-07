
vim.loader.enable()

local version = vim.version

local expected_ver = "0.10.0"
local ev = version.parse(expected_ver)
local current_ver = version()

local result_ver = version.cmp(ev, { current_ver.major, current_ver.minor, current_ver.patch })

if result_ver ~= 0 then
	local _v = string.format("%s.%s.%s", current_ver.major, current_ver.minor, current_ver.patch)
	local msg = string.format("Expect nvim v%s, but got %s instead. You're on your own!", expected_ver, _v)
	vim.api.nvim_err_writeln(msg)
end

local core_conf_files = {
    "globals.lua",
    "options.vim",
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
