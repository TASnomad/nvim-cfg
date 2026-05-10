-- LSP commands are not available anymore, let's recreate them for convenience

if vim.version().minor >= 12 then
    vim.api.nvim_create_user_command("LspLog", function()
        vim.cmd("tabedit " .. vim.lsp.log.get_filename())
    end, { desc = "Show LSP logs" })

    vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", { desc = "Show LSP info" })
    vim.api.nvim_create_user_command("LspRestart", "lsp restart", { desc = "Show LSP info" })
end
