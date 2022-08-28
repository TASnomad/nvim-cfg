local main_conf_files = {
	"globals.vim",
	"options.vim",
	"autocommands.vim",
    "mappings.vim",
    "plugins.vim",
    "themes.vim",
}

for _, name in ipairs(main_conf_files) do
	local p = string.format("%s/core/%s", vim.fn.stdpath("config"), name)
	local cmd = "source " .. p
	vim.cmd(cmd)
end
