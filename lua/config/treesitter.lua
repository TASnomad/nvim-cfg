require("nvim-treesitter.configs").setup({
    ensure_installed = { "python", "cpp", "lua", "vim", "rust", "go", "json", "jsonc" },
    ignore_install = {}, -- List of parsers to ignore installing
    highlight = {
        enable = true,   -- false will disable the whole extension
        disable = {},    -- list of language that will be disabled
    },
})
