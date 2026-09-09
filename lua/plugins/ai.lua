local function available_cli()
    if vim.fn.executable("codex") == 1 then
        return "codex"
    elseif vim.fn.executable("cursor-agent") == 1 then
        return "cursor"
    end
end

return {
    {
        "folke/sidekick.nvim",

        cond = function()
            return available_cli() ~= nil
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
                    -- Keep the session in Neovim's terminal: hiding the pane preserves it,
                    -- but quitting Neovim ends it. Use /resume in Codex after restarting
                    -- to restore the conversation, not any previously running task.
                    enabled = false,
                },
            },
        },

        keys = {
            {
                "<leader>aa",
                function()
                    require("sidekick.cli").toggle({
                        name = available_cli(),
                        focus = true,
                    })
                end,
                desc = "AI: Toggle assistant",
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
