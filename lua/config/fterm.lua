local fterm = require("FTerm")

---@diagnostic disable: missing-fields
fterm.setup({
    border = "double",
    dimensions = {
        height = 0.9,
        width = 0.9,
    },
})
---@diagnostic enable: missing-fields

vim.keymap.set('n', '<C-g>', '<cmd>lua require("FTerm").toggle()<CR>', { desc = "Toggle terminal" })
vim.keymap.set('t', '<C-g>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { desc = "Toggle terminal" })
