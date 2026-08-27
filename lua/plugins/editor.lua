local utils = require("utils")

return {
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        dependencies = {
            "jay-babu/mason-nvim-dap.nvim",
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            require("config.dap")
        end
    },
    -- TODO: highlight
    {
        "folke/todo-comments.nvim",
        config = function()
            require "todo-comments".setup({})
        end,
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    -- Comment plugin
    { "tpope/vim-commentary",   event = "VeryLazy" },
    { "simnalamburt/vim-mundo", cmd = { "MundoToggle", "MundoShow" } },
    -- Automatic insertion and deletion of a pair of characters
    { "Raimondi/delimitMate",   event = "InsertEnter" },
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
                    mode    = "diagnostics",
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
}
