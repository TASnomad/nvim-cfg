-- LSP commands are not available anymore, let's recreate them for convenience

local utils = require("utils")

if vim.version().minor >= 12 then
    vim.api.nvim_create_user_command("LspLog", function()
        vim.cmd("tabedit " .. vim.lsp.log.get_filename())
    end, { desc = "Show LSP logs" })

    vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", { desc = "Show LSP info" })
    vim.api.nvim_create_user_command("LspRestart", "lsp restart", { desc = "Restart LSP server" })
    vim.api.nvim_create_user_command("LspStart", "lsp enable", { desc = "Start LSP server" })
end

vim.api.nvim_create_user_command(
  "Edit",
  function(opts) utils.multi_edit(opts.fargs) end,
  {
    bar = true,
    bang = true,
    nargs = "*",
    complete = "file"
  })

vim.api.nvim_create_user_command(
  "Datetime",
  function(opts)
    local args = opts.args ~= "" and tonumber(opts.args) or nil
    vim.print(utils.iso_time(args))
  end,
  {
    nargs = "?"
  }
)

utils.cabbrev("edit", "Edit")
utils.cabbrev("man", "Man")
