local utils = require("utils")
local keymap = vim.keymap

keymap.set("n", "k", "kzz")
keymap.set("n", "j", "jzz")
keymap.set("n", "p", "pzz")
keymap.set("n", "P", "Pzz")
keymap.set("n", "G", "Gzz")
keymap.set("n", "x", "xzz")
keymap.set("n", "<PageUp>", "<PageUp>zz")
keymap.set("n", "<PageDown>", "<PageDown>zz")

keymap.set("n", "<C-H>", "<C-W><C-H>")
keymap.set("n", "<C-K>", "<C-W><C-K>")
keymap.set("n", "<C-L>", "<C-W><C-L>")
keymap.set("n", "<C-J>", "<C-W><C-J>")

-- Clearing search highlights in normal mode
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Continuous visual shifting (does not exit Visual mode), `gv` means
-- to reselect previous visual area, see https://superuser.com/q/310417/736190
keymap.set("x", "<", "<gv")
keymap.set("x", ">", ">gv")

keymap.set("n", "<leader>ev", "<cmd>tabnew $MYVIMRC  <bar> tcd %:h<cr>", {
  silent = true,
  desc = "Open nvim init.lua file"
})

keymap.set("n", "gx", "<cmd>:sil !open <cWORD><cr>", {
  silent = true,
  noremap = false
})

keymap.set("n", "<leader>bk", ":bd<cr>", {
  silent = true,
})

keymap.set("n", "<leader>sv", function()
  vim.cmd([[
        update $MYVIMRC
        source $MYVIMRC
    ]])
  vim.notify("Nvim config reloaded!", vim.log.levels.INFO, { title = "nvim-config" })
end, {
  silent = true,
  desc = "Reload nvim config"
})

keymap.set("n", "<space>o", "printf('m`%so<ESC>``', v:count1)", {
  expr = true,
  desc = "Insert line below"
})

keymap.set("n", "<space>O", "printf('m`%sO<ESC>``', v:count1)", {
  expr = true,
  desc = "Insert line above"
})

-- Reselect the text that has just been pasted, see also https://stackoverflow.com/a/4317090/6064933.
keymap.set("n", "<leader>v", "printf('`[%s`]', getregtype()[0])", {
  expr = true,
  desc = "reselect last pasted area",
})

-- Always use very magic mode for searching
keymap.set("n", "/", [[/\v]], {
  desc = "Search in open buffers"
})

-- Close location list or quickfix list if they are present, see https://superuser.com/q/355325/736190
keymap.set("n", [[\x]], "<cmd>windo lclose <bar> cclose <cr>", {
  silent = true,
  desc = "close qf and location list",
})

-- Delete a buffer, without closing the window, see https://stackoverflow.com/q/4465095/6064933
keymap.set("n", [[\d]], "<cmd>bprevious <bar> bdelete #<cr>", {
  silent = true,
  desc = "delete buffer",
})

-- Use Esc to quit builtin terminal
keymap.set("t", "<Esc>", [[<c-\><c-n>]])

--  Keep cursor position after yanking
keymap.set({ "n", "x" }, "y", "myy")

-- Neovide specific mappings
if vim.g.neovide then
  if vim.g.is_mac then
    local keymapOpts = { noremap = true, silent = true }
    -- Using system clipboard
    keymap.set({ "n", "v" }, "<D-c>", '"+y<CR>', keymapOpts)
    keymap.set({ "n", "v" }, "<D-v>", '"+p<CR>', keymapOpts)
    keymap.set({ "t", "!" }, "<D-v>", "<C-R>+", keymapOpts)
    keymap.set({ "n", "v" }, "<D-x>", '"+x', keymapOpts)
  end
end

-- Move current line up and down
keymap.set(
  "n",
  "<A-k>",
  function()
    utils.switch_line(vim.fn.line("."), "up")
  end,
  { desc = "move line up" }
)

keymap.set(
  "n",
  "<A-j>",
  function()
    utils.switch_line(vim.fn.line("."), "down")
  end,
  { desc = "move line down" }
)

-- Move current visual-line selection up and down
keymap.set(
  "x",
  "<A-k>",
  function()
    utils.move_selection("up")
  end,
  { desc = "move selection up" }
)

keymap.set(
  "x",
  "<A-j>",
  function()
    utils.move_selection("down")
  end,
  { desc = "move selection down" }
)

keymap.set("n", "<leader>u", "<cmd>MundoToggle<cr>", {
  silent = true,
  desc = "Interactive mundo"
})

keymap.set("n", "<leader>ff", function() require('telescope.builtin').find_files() end, {
  desc = "Search files"
})

keymap.set("n", "<leader>fg", function() require('telescope.builtin').live_grep() end, {
  desc = "Grep search"
})

keymap.set("n", "<leader>fh", function() require('telescope.builtin').help_tags() end, {
  desc = "Search vim in help files"
})

keymap.set("n", "<leader>ft", function() require('telescope.builtin').tags() end, {
  desc = "Search tags in current buffer"
})

keymap.set("n", "<leader>fb", function() require('telescope.builtin').buffers() end, {
  desc = "Search buffers"
})

keymap.set("n", "<leader>fr", function() require('telescope.builtin').oldfiles() end, {
  desc = "Search recent files"
})

keymap.set("n", "<leader>tv", "<cmd>TodoTrouble<cr>", {
  desc = "List all TODOs"
})

keymap.set('n', "<leader>pp", "<cmd>Telescope neovim-project discover<cr>", {
  desc = "List all projects found"
})

keymap.set('n', "<leader>pr", "<cmd>Telescope neovim-project<cr>", {
  desc = "List recent projects"
})
