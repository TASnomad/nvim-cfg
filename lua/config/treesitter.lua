-- FIXME: Might be worth checking why there is no "s" when using this package on darwin system
local pkg_name = vim.g.is_mac and "nvim-treesitter.configs" or "nvim-treesitter.config"

require(pkg_name).setup({
    ensure_installed = { "python", "cpp", "lua", "vim", "rust", "go", "json", "jsonc", "heex", "eex", "css", "elixir", "html" },
    ignore_install = {}, -- List of parsers to ignore installing
    highlight = {
        enable = true,   -- false will disable the whole extension
        disable = {},    -- list of language that will be disabled
    },
})
