local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local git_tui_cmd = "lazygit"

local git_client = Terminal:new {
    cmd = git_tui_cmd,
    hidden = true,
    direction = "float",
    float_opts = {
        border = "double",
    },
}

local terminal_client = Terminal:new {
    cmd = "zsh",
    hidden = true,
    direction = "float",
    float_opts = {
        border = "double"
    }
}

function M.git_client_toggle()
    git_client:toggle()
end

function M.term_toggle()
    terminal_client:toggle()
end

return M
