return {
    {
        "folke/sidekick.nvim",

        cond = function()
            return vim.fn.executable("codex") == 1
        end,

        dependencies = {
            "folke/snacks.nvim",
        },

        opts = {
            nes = {
                enabled = false,
            },

            cli = {
                watch = true,
                picker = "snacks",

                win = {
                    layout = "right",
                    split = {
                        width = 80,
                    },
                },

                mux = {
                    enabled = vim.fn.executable("tmux") == 1,
                    backend = "tmux",
                    create = "terminal",
                },
            },
        },

        keys = {
            {
                "<leader>aa",
                function()
                    require("sidekick.cli").toggle({
                        name = "codex",
                        focus = true,
                    })
                end,
                desc = "AI: Toggle Codex",
            },
            {
                "<leader>as",
                function()
                    require("sidekick.cli").select({
                        filter = { installed = true },
                    })
                end,
                desc = "AI: Select assistant",
            },
            {
                "<C-.>",
                function()
                    require("sidekick.cli").focus()
                end,
                mode = { "n", "i", "x", "t" },
                desc = "AI: Focus assistant",
            },
            {
                "<leader>af",
                function()
                    require("sidekick.cli").send({ msg = "{file}" })
                end,
                desc = "AI: Send file path",
            },
            {
                "<leader>at",
                function()
                    require("sidekick.cli").send({ msg = "{this}" })
                end,
                mode = { "n", "x" },
                desc = "AI: Send current context",
            },
            {
                "<leader>av",
                function()
                    require("sidekick.cli").send({ msg = "{selection}" })
                end,
                mode = "x",
                desc = "AI: Send selection",
            },
            {
                "<leader>ap",
                function()
                    require("sidekick.cli").prompt()
                end,
                mode = { "n", "x" },
                desc = "AI: Select prompt",
            },
            {
                "<leader>ad",
                function()
                    require("sidekick.cli").close()
                end,
                desc = "AI: Detach session",
            },
        },
    },
}
