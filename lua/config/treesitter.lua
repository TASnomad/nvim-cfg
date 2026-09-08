if vim.fn.executable("tree-sitter") == 1 then
    require("nvim-treesitter").install({
        "python", "cpp", "lua", "vim", "rust", "go", "json", "heex", "eex", "css", "elixir", "html",
    })
else
    vim.schedule(function()
        vim.notify(
            "tree-sitter CLI not found in PATH; parser installation skipped. Install tree-sitter CLI (on macOS: brew install tree-sitter).",
            vim.log.levels.WARN,
            { title = "Treesitter" }
        )
    end)
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
    callback = function(args)
        -- Parsers may be unavailable or still installing.
        pcall(vim.treesitter.start, args.buf)
    end,
})
