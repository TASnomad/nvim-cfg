local utils = require("utils")

-- Do not use smart case in command line mode, extracted from https://vi.stackexchange.com/a/16511/15292.
local dynamic_smartcase_group = vim.api.nvim_create_augroup('dynamic_smartcase', { clear = true })
vim.api.nvim_create_autocmd({ 'CmdLineEnter' }, {
  group = dynamic_smartcase_group,
  pattern = ':',
  command = 'set nosmartcase'
})
vim.api.nvim_create_autocmd({ 'CmdLineLeave' }, {
  group = dynamic_smartcase_group,
  pattern = ':',
  command = 'set smartcase'
})

-- Do not use number and relative number for terminal inside nvim
local term_settings_group = vim.api.nvim_create_augroup('term_settings', { clear = true })
vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  group = term_settings_group,
  pattern = '*',
  command = 'setlocal norelativenumber nonumber'
})
-- Go to insert mode by default to start typing command
vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  group = term_settings_group,
  pattern = '*',
  command = 'startinsert'
})

-- More accurate syntax highlighting? (see `:h syn-sync`)
local accurate_syn_highlight_group = vim.api.nvim_create_augroup('accurate_syn_highlight', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  group = accurate_syn_highlight_group,
  pattern = '*',
  command = 'syntax sync fromstart'
})

local numbertoggle_group = vim.api.nvim_create_augroup('numbertoggle', { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = numbertoggle_group,
  pattern = '*',
  command = 'if &nu | set rnu   | endif'
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = numbertoggle_group,
  pattern = '*',
  command = 'if &nu | set nornu | endif'
})


-- Format with LSP client
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format { async = false, id = args.data.client_id }
      end
    })
  end
})

-- Display a message when the current file is not in utf-8 format.
-- Note that we need to use `unsilent` command here because of this issue:
-- https://github.com/vim/vim/issues/4379
vim.api.nvim_create_autocmd({ "BufRead" }, {
  group = vim.api.nvim_create_augroup("non_utf8_file", { clear = true }),
  pattern = '*',
  callback = function()
    if vim.bo.fileencoding ~= 'utf-8' then
      vim.notify("File not in UTF-8 format!", vim.log.levels.WARN, { title = "File format" })
    end
  end
})

-- highlight yanked region, see `:h lua-highlight`
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = "*",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank { higroup = "YankColor", timeout = 300, on_visual = false }
  end
})

-- Auto-generate packer_compiled.lua file
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = "*/nvim/lua/plugins.lua",
  group = vim.api.nvim_create_augroup("packer_auto_compile", { clear = true }),
  callback = function(ctx)
    local cmd = "source " .. ctx.file
    vim.cmd(cmd)
    vim.cmd("PackerCompile")
  end
})

-- Auto-create directory when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(ctx)
    local dir = vim.fn.fnamemodify(ctx.file, ":p:h")
    utils.may_create_dir(dir)
  end
})

-- Automatically reload the file if it is changed outside of Nvim, see https://unix.stackexchange.com/a/383044/221410.
-- It seems that `checktime` does not work in command line. We need to check if we are in command
-- line before executing this command, see also https://vi.stackexchange.com/a/20397/15292 .
local auto_read_group = vim.api.nvim_create_augroup('auto_read', { clear = true })

vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
  pattern = '*',
  group = auto_read_group,
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.WARN, { title = "File watcher" })
  end
})
vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold" }, {
  pattern = '*',
  group = auto_read_group,
  callback = function()
    if vim.fn.getcmdwintype() == '' then
      vim.cmd("checktime")
    end
  end
})

local large_file_group = vim.api.nvim_create_augroup('LargeFile', { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  pattern = '*',
  group = large_file_group,
  -- solution from: https://vi.stackexchange.com/a/169/15292
  callback = function()
    local large_fsize = 10485760 -- 10MB
    local file = vim.fn.expand('<afile>')
    local stat = vim.fn.getfsize(file)

    if stat > large_fsize or stat == -2 then
      vim.opt.eventignore:append { "all" }
      vim.o.relativenumber = true
      vim.cmd('setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1')
    else
      vim.opt.eventignore:remove { "all", "relativenumber" }
    end
  end
})
