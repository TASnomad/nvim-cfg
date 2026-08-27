-- auto-completion engine

return {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    opts = {
        sources = {
            default = {
                "lsp",
                "path",
                "snippets",
                "buffer",
            },
        },

        completion = {
            list = {
                selection = {
                    preselect = true,
                    auto_insert = true,
                },
            },

            menu = {
                border = "rounded",
                draw = {
                    columns = {
                        { "kind_icon",        "label", gap = 1 },
                        { "label_description" },
                    },
                },
            },

            documentation = {
                auto_show = true,
                auto_show_delay_ms = 100,

                window = {
                    border = "rounded",
                },
            },
        },

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

        cmdline = {
            enabled = true,
            completion = {
                menu = {
                    auto_show = true,
                },

                list = {
                    selection = {
                        preselect = true,
                        auto_insert = true,
                    },
                },
            },

            keymap = {
                preset = "cmdline",

                ["<Tab>"] = {
                    "show_and_insert_or_accept_single",
                    "select_next",
                },

                ["<S-Tab>"] = {
                    "show_and_insert_or_accept_single",
                    "select_prev",
                },

                ["<C-y>"] = {
                    "select_and_accept",
                    "fallback",
                },

                ["<C-e>"] = {
                    "cancel",
                    "fallback",
                },
            },

            sources = {
                "cmdline",
                "buffer",
            },
        },
    }
}
