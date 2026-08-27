return {
    -- Show git change (change, delete, add) signs in vim sign column
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("config.gitsigns")
        end,
    },
    {
        "tpope/vim-fugitive",
        -- event = "User InGitRepo",
        config = function()
            require("config.fugitive")
        end,
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",  -- required
            "sindrets/diffview.nvim", -- optional - Diff integration
        }
    },
}
