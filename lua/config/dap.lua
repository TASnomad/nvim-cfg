require("mason").setup()

local mason_dap = require("mason-nvim-dap")
local dap       = require("dap")
local dapui     = require("dapui")

mason_dap.setup({
  ensure_installed = { "codelldb" },
  automatic_installation = true,
  handlers = {
    function(config)
      mason_dap.default_setup(config)
    end,
  },
})

dapui.setup()

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = "codelldb",
    args = { "--port", "${port}" },
  }
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopAtEntry = false,
    MIMode = "lldb"
  },
  {
    name = "Attach to lldbserver :1234",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    MIMode = "lldb",
    miDebuggerServerAdddress = "localhost:1234",
    miDebuggerPath = "/usr/bin/lldb"
  }
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
