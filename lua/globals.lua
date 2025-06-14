local fn = vim.fn

local api = vim.api

local utils = require("utils")

function _G.inspect(item)
  vim.print(item)
end

vim.g.is_win = (utils.has("win32") or utils.has("win64")) and true or false
vim.g.is_linux = (utils.has("unix") and (not utils.has("macunix"))) and true or false
vim.g.is_mac = utils.has("macunix") and true or false

vim.g.logging_level = "info"

-- Disable perl provider
vim.g.loaded_perl_provider = 0
-- Disable ruby provider
vim.g.loaded_ruby_provider = 0
-- Disable node provider
vim.g.loaded_node_provider = 0
-- do not load menu
vim.g.did_install_default_menus = 1


if utils.executable('python3') then
  if vim.g.is_win then
    vim.g.python3_host_prog = fn.substitute(fn.exepath("python3"), ".exe$", '', 'g')
  else
    vim.g.python3_host_prog = fn.exepath("python3")
  end
else
  api.nvim_echo({ { "Python3 executable not found! You must install Python3 and set its PATH correctly!" } }, true,
    { err = true })
  return
end

vim.g.mapleader = " "

vim.g.vimsyn_embed = 'l'


-- if not vim.g.is_mac then
--vim.cmd("language en_US.UTF-8")
-- end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_liststyle = 3

if vim.g.is_win then
  vim.netrw_http_cmd = 'curl --ssl-no-revoke -Lo'
end


vim.g.loaded_2html_plugin = 1


-- Do not load zipPlugin.vim, gzip.vim and tarPlugin.vim (all these plugins are
-- related to checking files inside compressed files)
vim.g.loaded_zipPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1

-- Do not load the tutor plugin
vim.g.loaded_tutor_mode_plugin = 1

-- Do not use builtin matchit.vim and matchparen.vim since we use vim-matchup
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

-- Disable sql omni completion, it is broken.
vim.g.loaded_sql_completion = 1
