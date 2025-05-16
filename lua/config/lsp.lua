local fn = vim.fn
local api = vim.api
local lsp = vim.lsp

local mason_lspconfig = require("mason-lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.enable('biome')
vim.lsp.enable('docker_compose_language_service')
vim.lsp.enable('dockerls')

local servers = {
    pylsp = {
        pylsp = {
            plugins = {
                pylint = { enabled = true, executable = "pylint" },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                jedi_completion = { fuzzy = true },
                pyls_isort = { enabled = true },
                pylsp_mypy = { enabled = true },
            },
        }
    },
    tl_ls = {},
    vimls = {},
    lua_ls = {
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
                    fn.stdpath('config'),
                    fn.expand("$VIMRUNTIME/lua"),
                    fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                    fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                },
                maxPreload = 2000,
                preloadFileSize = 50000,
            },
        },
    },
    nil_ls = {
        ['nil'] = {
            formatting = {
                command = { 'alejandra' }
            }
        }
    },
    bashls = {},
    graphql = {},
    ruby_lsp = {},
    jsonls = {},
}

local function merge(t1, t2)
    local r = t1
    for k, v in pairs(t2) do
        if (type(v) == "table") and (type(r[k] or false) == "table") then
            merge(r[k], t2[k])
        else
            r[k] = v
        end
    end
    return r
end

local custom_attach = function(client, bufnr)
    -- Mappings.
    local opts = { silent = true, buffer = bufnr, noremap = true }

    -- Using LSP as the handler for omnifunc (deprecated: automatically installed)
    -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, merge(opts, { desc = "go to definition" }))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, merge(opts, { desc = "go to declaration" }))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    -- vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<space><C-k>", vim.lsp.buf.signature_help, merge(opts, { desc = "Show signature" }))
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function() inspect(vim.lsp.buf.list_workspace_folders()) end, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, merge(opts, { desc = "Show references" }))
    vim.keymap.set("n", "gp", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "gn", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<space>q", function() vim.diagnostic.setqflist({ open = true }) end,
        merge(opts, { desc = "Show diagnostics in quickfix list" }))
    -- vim.keymap.set("n", "<space>q", function() vim.diagnostic.setloclist({open = true}) end, merge(opts, { desc = "Show diagnostics in loclist list" }))
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, merge(opts, { desc = "Show LSP actions" }))

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

    -- if client.server_capabilities.documentFormattingProvider then
    --     vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting_sync, opts)
    -- end

    -- Set some key bindings conditional on server capabilities
    if client.server_capabilities.document_formatting then
        vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting_sync, opts)
    end
    if client.server_capabilities.document_range_formatting then
        vim.keymap.set("x", "<space>f", vim.lsp.buf.range_formatting, opts)
    end

    -- The blow command will highlight the current variable and its usages in the buffer.
    if client.server_capabilities.document_highlight then
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
        vim.notify(msg, vim.log.levels.INFO, { title = 'Nvim-config LSP' })
    end
end


require("neoconf").setup({})

require("mason").setup()
mason_lspconfig.setup({
    automatic_installation = true,
    ensured_installed = vim.tbl_keys(servers),
    handlers = {
        function(server_name)
            require("lspconfig")[server_name].setup {
                capabilities = capabilities,
                on_attach = custom_attach,
                settings = servers[server_name],
                filetypes = (servers[server_name] or {}).filetypes,
            }
        end
    }
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
