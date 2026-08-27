return {
    "folke/neoconf.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "folke/neoconf.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("config.lsp")
        end,
    },
}
