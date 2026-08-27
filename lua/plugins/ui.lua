return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("config.which-key")
        end,
    },
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        config = function()
            require("config.bqf")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        build = ":TSUpdate",
        branch = "main",
        config = function()
            require("config.treesitter")
        end,
    },
    { "nvim-tree/nvim-web-devicons", event = "VeryLazy" },
    -- Highlight URLs inside vim
    { "itchyny/vim-highlighturl",    event = "VeryLazy" },
    {
        "akinsho/bufferline.nvim",
        event = { "BufEnter" },
        config = function()
            require("config.bufferline")
        end,
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
    -- better UI for some nvim actions
    {
        "folke/snacks.nvim",
        opts = {
            input = {},
            picker = {
                ui_select = true,
            },
        },
    },
    { "akinsho/git-conflict.nvim", version = "*", config = true },
    {
        "nvim-telescope/telescope.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-symbols.nvim",
        },
        config = function()
            require("telescope").setup({})
        end
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("config.nvim-tree")
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("config.statusline")
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = function()
            require("config.ident-blankline")
        end
    },
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            require("config.nvim-notify")
        end,
    },
    {
        "folke/tokyonight.nvim",
        config = function()
            vim.cmd("colorscheme tokyonight-storm")
        end
    },
    {
        "catgoose/nvim-colorizer.lua",
        event = "BufReadPre",
        config = function()
            require("colorizer").setup({
                filetypes = { "*" },
                user_default_options = {
                    hex                = { default = true },
                    rgb                = { enable = true },
                    hsl                = { enable = true },
                    mode               = "virtualtext", -- or "background", "foreground", "underline"
                    virtualtext        = "■",
                    virtualtext_inline = true
                }
            })
        end
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            cmdline = {
                enabled = true,
                view = "cmdline_popup",

                format = {
                    cmdline = {
                        pattern = "^:",
                        icon = "",
                        lang = "vim",
                    },

                    search_down = {
                        kind = "search",
                        pattern = "^/",
                        icon = " ",
                        lang = "regex",
                    },

                    search_up = {
                        kind = "search",
                        pattern = "^%?",
                        icon = " ",
                        lang = "regex",
                    },
                },
            },

            popupmenu = {
                backend = "nui"
            },

            presets = {
                command_palette = true,
                long_message_to_split = true,
                lsp_doc_border = true,
            },
        },
    },
    {
        "numToStr/FTerm.nvim",
        config = function()
            require("config.fterm")
        end
    },
}
