local utils = require("utils")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end

vim.opt.rtp:prepend(lazypath)

local plugin_specs = {
    -- auto-completion engine
    {
        "hrsh7th/nvim-cmp",
        -- event = 'InsertEnter',
        event = "VeryLazy",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "onsails/lspkind-nvim",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-omni",
            "hrsh7th/cmp-emoji",
            "quangnguyen30192/cmp-nvim-ultisnips",
        },
        config = function()
            require("config.nvim-cmp")
        end,
    },
    {
        "SirVer/ultisnips",
        event = "InsertEnter",
    },
    {
        "sbdchd/neoformat",
        cmd = { "Neoformat" }
    },
    "folke/neoconf.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    {
        "neovim/nvim-lspconfig",
        event = { "BufRead", "BufNewFile" },
        config = function()
            require("config.lsp")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        enabled = function()
            if vim.g.is_mac then
                return true
            end
            return false
        end,
        event = "VeryLazy",
        build = ":TSUpdate",
        config = function()
            require("config.treesitter")
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function ()
           require("config.which-key")
        end,
    },
    -- TODO: highlight
    {
      "folke/todo-comments.nvim",
      config = function ()
        require"todo-comments".setup({})
      end,
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    -- Comment plugin
    { "tpope/vim-commentary", event = "VeryLazy" },
    { "simnalamburt/vim-mundo", cmd = { "MundoToggle", "MundoShow" } },
    -- Automatic insertion and deletion of a pair of characters
    { "Raimondi/delimitMate", event = "InsertEnter" },
    "nvim-lua/plenary.nvim",
    -- The missing auto-completion for cmdline!
    {
        "gelguy/wilder.nvim",
        build = ":UpdateRemotePlugins",
    },
    { "nvim-tree/nvim-web-devicons", event = "VeryLazy" },
    -- Highlight URLs inside vim
    { "itchyny/vim-highlighturl", event = "VeryLazy" },
    {
        "akinsho/bufferline.nvim",
        event = { "BufEnter" },
        config = function()
            require("config.bufferline")
        end,
    },
    -- better UI for some nvim actions
    { "stevearc/dressing.nvim" },
    { "akinsho/git-conflict.nvim", version = "*", config = true },
    "sindrets/diffview.nvim",
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        config = function()
            require("config.bqf")
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        -- cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-symbols.nvim",
        },
    },
    {
        "coffebar/neovim-project",
        opts = {
            projects = {
                "~/projects/*",
                "~/p*cts/*", -- glob pattern is supported
                "~/projects/repos/*",
                "~/.config/*",
                "~/work/*",
                "~/Documents/*",
                "~/sandbox/*",
            },
        },
        init = function ()
            -- enable saving the state of plugins in the session
            vim.opt.sessionoptions:append("globals") -- save global variables that start with an upper
        end,
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
            { "Shatur/neovim-session-manager" },
        },
        lazy = false,
        priority = 100,
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            icons = {
                indent = {
                    middle = " ",
                    last = " ",
                    top = " ",
                    ws = "│  ",
                },
            },
            modes = {
                -- diagnostics = {
                --     groups = {
                --         { "filename", format = "{file_icon} {basename:Title} {count}" },
                --     },
                -- },
                cascade = {
                    mode = "diagnostics",
                    filter = function(items)
                        local severity = vim.diagnostic.severity.HINT
                        for _, item in ipairs(items) do
                            severity = math.min(severity, item.severity)
                        end
                        return vim.tbl_filter(function(item) return item.severity == severity end, items)
                    end,
                    preview = {
                        type = "float",
                        relative = "editor",
                        border = "rounded",
                        title = "Preview",
                        title_pos = "center",
                        position = { 0, -2 },
                        size = { width = 0.3, height = 0.3 },
                        zindex = 200,
                    }
                },
                preview_float = {
                mode  = "diagnostics",
                preview = {
                        type = "float",
                        relative = "editor",
                        border = "rounded",
                        title = "Preview",
                        title_pos = "center",
                        position = { 0, -2 },
                        size = { width = 0.3, height = 0.3 },
                        zindex = 200,
                    }
                },
                preview_split = {
                    mode = "diagnostics",
                    preview = {
                        type = "split",
                        relative = "win",
                        position = "right",
                        size = 0.3
                    }
                },
            },
        },
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble<cr>",
                desc = "Trouble"
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer diagnostics"
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols foucs=false<cr>",
                desc = "Symbols (Trouble)"
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP definition / references / ... (Trouble)"
            },
            {
                "<leader>xL",
                "<leader>Trouble loclist toggle<cr>",
                desc = "Location list (Trouble)"
            },
            {
                "<leader>xQ",
                "<leader>Trouble qflist toggle<cr>",
                desc = "Quickfix list (Trouble)"
            }
        }
    },
    -- Show git change (change, delete, add) signs in vim sign column
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("config.gitsigns")
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        keys = { "<space>op" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("config.nvim-tree")
        end,
    },
    -- Since tmux is only available on Linux and Mac, we only enable these plugins
    -- for Linux and Mac
    -- .tmux.conf syntax highlighting and setting check
    {
        "tmux-plugins/vim-tmux",
        enabled = function()
            if utils.executable("tmux") then
                return true
            end
            return false
        end,
        ft = { "tmux" },
    },
    {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        tag = "legacy",
        config = function()
            require("config.fidget-nvim")
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        -- event = { "VimEnter" },
        config = function()
            require("config.statusline")
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        -- event = { "VimEnter" },
        config = function()
            require("config.ident-blankline")
        end
    },
    {
        "sainnhe/edge",
        config = function()
            vim.cmd("colorscheme edge")
        end
    },
    { 'wakatime/vim-wakatime', lazy = false },
}

local lazy_opts = {
    ui = {
        border = "rounded",
        title = "Plugin manager",
        title_pos = "center",
    },
}

require("lazy").setup(plugin_specs, lazy_opts)
