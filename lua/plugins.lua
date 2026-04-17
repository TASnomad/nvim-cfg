local utils = require("utils")

require("plugin_specs")

-- Use short names for common plugin manager commands to simplify typing.
-- To use these shortcuts: first activate command line with `:`, then input the
-- short alias, e.g., `pi`, then press <space>, the alias will be expanded to
-- the full command automatically.
utils.cabbrev('pi', 'Lazy install')
utils.cabbrev('pud', 'Lazy update')
utils.cabbrev('pc', 'Lazy clean')
utils.cabbrev('ps', 'Lazy sync')

vim.defer_fn(function()
  local ok, wilder = pcall(require, "wilder")
  if not ok then
    vim.notify("Wilder.nvim missing", vim.log.levels.ERROR)
  end

  wilder.setup({
    modes = { ":", "/", "?" },
    next_key = "<Tab>",
    previous_key = "<S-Tab>",
    accept_key = "<C-y>",
    reject_key = "<C-e>"
  })

  wilder.set_option("pipeline", {
    wilder.branch(
      wilder.cmdline_pipeline({
        language = "python",
        fuzzy = 1,
        sorter = wilder.python_difflib_sorter(),
        debounce = 30
      }),
      wilder.python_search_pipeline({
        pattern = wilder.python_fuzzy_pattern(),
        sorter = wilder.python_difflib_sorter(),
        engine = 're',
        debounce = 30
      })
    )
  })

  local hl = wilder.make_hl("WilderAccent", "Pmenu", { {}, {}, { foreground = "#f4468f" } })

  wilder.set_option("renderer", wilder.popupmenu_renderer(
    wilder.popupmenu_border_theme({
      highlighter         = wilder.basic_highlighter(),
      highlights          = {
        border = "normal",
        accent = hl,
      },
      border              = "rounded",
      empty_message       = wilder.popupmenu_empty_message_with_spinner(),
      left                = { " ", wilder.popupmenu_devicons() },
      right               = { " ", wilder.popupmenu_scrollbar() },
      apply_incsearch_fix = 0,
      min_width           = "100%",
      min_height          = "15%",
      pumblend            = 20,
    })
  ))
end, 250)
