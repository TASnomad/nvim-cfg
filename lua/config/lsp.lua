local fn = vim.fn
local api = vim.api
local lsp = vim.lsp

local utils = require("utils")

require("mason").setup()
require("mason-lspconfig").setup({
    automatic_installation = {
        "pylsp",
        "rust-analyzer",
        "gopls",
        "tsserver",
        "svelte",
        "clangd",
        "vimls",
        "sumneko_lua",
        "bashls",
    },
    ensured_installed = {
        "pylsp",
        "rust-analyzer",
        "gopls",
        "tsserver",
        "svelte",
        "clangd",
        "vimls",
        "sumneko_lua",
        "bashls",
    }
})

local custom_attach = function(client, bufnr)
    -- Mappings.
    local opts = { silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    -- vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<space><C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function() inspect(vim.lsp.buf.list_workspace_folders()) end, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gp", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "gn", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<space>q", function() vim.diagnostic.setqflist({open = true}) end, opts)
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)

    api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local float_opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = "rounded",
                source = "always",
                prefix = " ",
            }

            if not vim.b.diagnostics_pos then
                vim.b.diagnostics_pos = { nil, nil }
            end

            local cursor_pos = api.nvim_win_get_cursor(0)
            if (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2]) and #vim.diagnostic.get() > 0 then
                vim.diagnostic.open_float(nil, float_opts)
            end

            vim.b.diagnostics_pos = cursor_pos
        end
    })

    -- Set some key bindings conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting_sync, opts)
    end
    if client.resolved_capabilities.document_range_formatting then
        vim.keymap.set("x", "<space>f", vim.lsp.buf.range_formatting, opts)
    end

    -- The blow command will highlight the current variable and its usages in the buffer.
    if client.resolved_capabilities.document_highlight then
        vim.cmd([[
        hi! link LspReferenceRead Visual
        hi! link LspReferenceText Visual
        hi! link LspReferenceWrite Visual
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]])
    end

    if vim.g.logging_level == 'debug' then
        local msg = string.format("Language server %s started!", client.name)
        vim.notify(msg, 'info', {title = 'Nvim-config LSP'})
    end
end

local capabilities = lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspconfig = require("lspconfig")

function lsp_command(path)
    return string.format("%s/%s", vim.fn.stdpath("data"), path)
end

local lsp_commands = {
    bash = lsp_command("/mason/packages/bash-language-server/node_modules/.bin/bash-language-server"),
    c = lsp_command("/mason/packages/clangd/clangd/bin/clangd"),
    go = lsp_command("/mason/packages/gopls/gopls"),
    py = lsp_command("/mason/packages/python-lsp-server/venv/bin/pylsp"),
    rust = lsp_command("/mason/packages/rust-analyzer/rust-analyzer"),
    lua = lsp_command("/mason/packages/lua-language-server/lua-language-server"),
    ts = lsp_command("/mason/packages/typescript-language-server/node_modules/.bin/typescript-language-server"),
    vim = lsp_command("/mason/packages/vim-language-server/node_modules/.bin/vim-language-server"),
    svelte = lsp_command("/mason/packages/svelte-language-server/node_modules/.bin/svelteserver"),
}

lspconfig.pylsp.setup({
    cmd = { lsp_commands["py"] },
    on_attach = custom_attach,
    settings = {
        pylsp = {
            plugins = {
                pylint = { enabled = true, executable = "pylint" },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                jedi_completion = { fuzzy = true },
                pyls_isort = { enabled = true },
                pylsp_mypy = { enabled = true },
            },
        },
    },
    flags = {
        debounce_text_changes = 200,
    },
    capabilities = capabilities,
})

lspconfig.rust_analyzer.setup({
    cmd = { lsp_commands["rust"] },
    on_attach = custom_attach,
    capabilities = capabilities,
})


lspconfig.gopls.setup({
    cmd = { lsp_commands["go"] },
    on_attach = custom_attach,
    capabilities = capabilities,
})

lspconfig.tsserver.setup({
    cmd = { lsp_commands["ts"], "--stdio" },
    on_attach = custom_attach,
    capabilities = capabilities,
})

lspconfig.svelte.setup({
    cmd = { lsp_commands["svelte"], "--stdio" },
    on_attach = custom_attach,
    capabilities = capabilities,
})

lspconfig.clangd.setup({
    cmd = { lsp_commands["c"] },
    on_attach = custom_attach,
    capabilities = capabilities,
    filetypes = { "c", "cpp", "cc" },
    flags = {
        debounce_text_changes = 500,
    },
})

-- set up vim-language-server
lspconfig.vimls.setup({
    cmd = { lsp_commands["vim"], "--stdio" },
    on_attach = custom_attach,
    flags = {
        debounce_text_changes = 500,
    },
    capabilities = capabilities,
})

-- set up bash-language-server
lspconfig.bashls.setup({
    cmd = { lsp_commands["bash"], "start" },
    on_attach = custom_attach,
    capabilities = capabilities,
})

-- settings for lua-language-server can be found on https://github.com/sumneko/lua-language-server/wiki/Settings .
lspconfig.sumneko_lua.setup({
    cmd = { lsp_commands["lua"] },
    on_attach = custom_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files,
                -- see also https://github.com/sumneko/lua-language-server/wiki/Libraries#link-to-workspace .
                -- Lua-dev.nvim also has similar settings for sumneko lua, https://github.com/folke/lua-dev.nvim/blob/main/lua/lua-dev/sumneko.lua .
                library = {
                    fn.stdpath('data') .. "/site/pack/packer/opt/emmylua-nvim",
                    fn.stdpath('config'),
                },
                maxPreload = 2000,
                preloadFileSize = 50000,
            },
        },
    },
    capabilities = capabilities,
})

-- Change diagnostic signs.
fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
fn.sign_define("DiagnosticSignWarn", { text = "!", texthl = "DiagnosticSignWarn" })
fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- global config for diagnostic
vim.diagnostic.config({
    underline = true,
    virtual_text = true,
    signs = true,
    severity_sort = true,
})

-- lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
--   underline = false,
--   virtual_text = false,
--   signs = true,
--   update_in_insert = false,
-- })

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})
