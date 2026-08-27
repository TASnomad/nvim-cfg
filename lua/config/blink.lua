local blink = require("blink.cmp")

blink.setup({
    -- nvim-cmp: snippet.expand
    snippets = {
        preset = "default",
    },

    -- nvim-cmp: sources
    sources = {
        default = {
            "lsp",
            "path",
            "buffer",
            "snippets",
        },
    },

    -- nvim-cmp: completion.keyworkd_length = 1
    completion = {
        keyword = {
            range = "full",
        },

        menu = {
            border = "rounded",
        },

        documentation = {
            auto_show = true,
            auto_show_delay_ms = 100,

            window = {
                border = "rounded",
            },
        },
    },

    -- nvim-cmp mappings
    keymap = {
        preset = "none",

        ["<Tab>"] = {
            "select_next",
            "fallback",
        },

        ["<S-Tab>"] = {
            "select_prev",
            "fallback",
        },

        ["<CR>"] = {
            "accept",
            "fallback",
        },

        ["<C-e>"] = {
            "cancel",
            "fallback",
        },

        ["<Esc>"] = {
            "cancel",
            "fallback",
        },

        ["<C-d>"] = {
            "scroll_documentation_up",
            "fallback",
        },

        ["<C-f>"] = {
            "scroll_documentation_down",
            "fallback",
        },
    },

    fuzzy = {
        implementation = "rust",
    },
})
