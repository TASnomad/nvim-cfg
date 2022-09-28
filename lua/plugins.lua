local utils = require("utils")
local fn = vim.fn

vim.g.plugin_home = fn.stdpath("data") .. "/site/pack/packer"

local packer_dir = vim.g.plugin_home .. "/opt/packer.nvim"

local fresh_install = false

if fn.glob(packer_dir) == "" then
    fresh_install = true

    local packer_repo = "https://github.com/wbthomason/packer.nvim"
    local install_cmd = string.format("!git clone --depth=1 %s %s", packer_repo, packer_dir)

    vim.api.nvim_echo({{ "Installing packer.nvim", "Type" }}, true, {})
    vim.cmd(install_cmd)
end

-- Load packer.nvim
vim.cmd("packadd packer.nvim")

local packer = require("packer")
local packer_util = require('packer.util')

packer.startup({
    function(use)
        -- NOTE: impatient.nvim should always be the first plugin loaded
        use { 'lewis6991/impatient.nvim' , config = [[require('impatient')]] }
        use({"wbthomason/packer.nvim", opt = true})

        -- LSP
        use({ "onsails/lspkind-nvim", event = "VimEnter" })
        use {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        }

        -- snippets
        use { 'L3MON4D3/LuaSnip' }

        -- LSP autocomplete
        use({ "hrsh7th/nvim-cmp", after = "lspkind-nvim", config = [[require('config.nvim-cmp')]] })
        -- nvim-cmp completion sources
        use {"hrsh7th/cmp-nvim-lsp", after = "nvim-cmp"}
        -- use {"hrsh7th/cmp-nvim-lua", after = "nvim-cmp"}
        use {"hrsh7th/cmp-path", after = "nvim-cmp"}
        use {"hrsh7th/cmp-buffer", after = "nvim-cmp"}
        use { "hrsh7th/cmp-omni", after = "nvim-cmp" }
        use {"quangnguyen30192/cmp-nvim-ultisnips", after = {'nvim-cmp', 'ultisnips'}}
        use({ "neovim/nvim-lspconfig", after = "cmp-nvim-lsp", config = [[require('config.lsp')]] })

        -- if vim.g.is_mac then
            use({
                "nvim-treesitter/nvim-treesitter",
                event = 'BufEnter',
                run = ":TSUpdate",
                config = [[require('config.treesitter')]]
            })
        -- end

        -- File search, tag search and more
        if vim.g.is_win then
            use({"Yggdroot/LeaderF", cmd = "Leaderf"})
        else
            use({ "Yggdroot/LeaderF", cmd = "Leaderf", run = ":LeaderfInstallCExtension" })
        end

        use {
           'nvim-telescope/telescope.nvim', cmd = 'Telescope',
            requires = { {'nvim-lua/plenary.nvim'} }
        }
        -- search emoji and other symbols
        use {'nvim-telescope/telescope-symbols.nvim', after = 'telescope.nvim'}

        -- A list of colorscheme plugin you may want to try. Find what suits you.
        use({"lifepillar/vim-gruvbox8", opt = true})
        use({"navarasu/onedark.nvim", opt = true})
        use({"sainnhe/edge", opt = true})
        use({"sainnhe/sonokai", opt = true})
        use({"sainnhe/gruvbox-material", opt = true})
        use({"shaunsingh/nord.nvim", opt = true})
        use({"NTBBloodbath/doom-one.nvim", opt = true})
        use({"sainnhe/everforest", opt = true})
        use({"EdenEast/nightfox.nvim", opt = true})
        use({"rebelot/kanagawa.nvim", opt = true})

        -- Show git (and others) change (change, delete, add) signs in vim sign column
        use({"mhinz/vim-signify", event = 'BufEnter'})

        use {'kyazdani42/nvim-web-devicons'}

        -- TODO: highlight
        use {
            "folke/todo-comments.nvim",
            requires = "nvim-lua/plenary.nvim",
            config = function ()
                require"todo-comments".setup{}
            end
        }

        use {
            'norcalli/nvim-colorizer.lua',
            config = function()
                require"colorizer".setup({
                    "css",
                    "javascript",
                    "typescript",
                    html = { mode = "background" }
                }, { mode = "foreground" })
            end
        }

        use {
            'nvim-lualine/lualine.nvim',
            event = 'VimEnter',
            config = [[require('config.statusline')]]
        }

        use({ "akinsho/bufferline.nvim", event = "VimEnter", config = [[require('config.bufferline')]] })

        use({
            "lukas-reineke/indent-blankline.nvim",
            event = 'VimEnter',
            config = [[require('config.indent-blankline')]]
        })

        -- Highlight URLs inside vim
        use({"itchyny/vim-highlighturl", event = "VimEnter"})

        -- notification plugin
        use({
            "rcarriga/nvim-notify",
            event = "BufEnter",
            config = function()
                vim.defer_fn(function() require('config.nvim-notify') end, 2000)
            end
        })

        -- Only install these plugins if ctags are installed on the system
        if utils.executable("ctags") then
            -- show file tags in vim window
            use({"liuchengxu/vista.vim", cmd = "Vista"})
        end

        -- Snippet engine and snippet template
        use({"SirVer/ultisnips", event = 'InsertEnter'})
        use({ "honza/vim-snippets", after = 'ultisnips'})

        -- Automatic insertion and deletion of a pair of characters
        use({"Raimondi/delimitMate", event = "InsertEnter"})

        -- Comment plugin
        use({"tpope/vim-commentary", event = "VimEnter"})

        -- Show undo history visually
        use({"simnalamburt/vim-mundo", cmd = {"MundoToggle", "MundoShow"}})

        use({ "sbdchd/neoformat", cmd = { "Neoformat" } })

        -- Git command inside vim
        use({ "tpope/vim-fugitive", opt = false })
        -- Better git log display
        use({ "rbong/vim-flog", requires = "tpope/vim-fugitive", cmd = { "Flog" }, opt = false })
        use({ "christoomey/vim-conflicted", requires = "tpope/vim-fugitive", cmd = {"Conflicted"}})

        use({ "kevinhwang91/nvim-bqf", ft = "qf", config = [[require('config.bqf')]] })

        -- Since tmux is only available on Linux and Mac, we only enable these plugins
        -- for Linux and Mac
        if utils.executable("tmux") then
            -- .tmux.conf syntax highlighting and setting check
            use({ "tmux-plugins/vim-tmux", ft = { "tmux" } })
        end

        -- Modern matchit implementation
        use({"andymass/vim-matchup", event = "VimEnter"})

         -- Asynchronous command execution
         use({ "skywind3000/asyncrun.vim", opt = true, cmd = { "AsyncRun" } })

        use({ "cespare/vim-toml", ft = { "toml" }, branch = "main" })

        -- showing keybindings
        use {
            "folke/which-key.nvim",
            event = "VimEnter",
            config = function()
                vim.defer_fn(function() require('config.which-key') end, 2000)
            end
        }

        -- The missing auto-completion for cmdline!
        use({"gelguy/wilder.nvim", opt = true, setup = [[vim.cmd('packadd wilder.nvim')]]})

        -- file explorer
        use {
            'kyazdani42/nvim-tree.lua',
            requires = { 'kyazdani42/nvim-web-devicons' },
            config = [[require('config.nvim-tree')]]
        }

        use { 'j-hui/fidget.nvim', after = 'nvim-lspconfig', config = [[require('config.fidget-nvim')]]}

        -- Wakatime
        use { "wakatime/vim-wakatime" }
    end,
    config = {
        max_jobs = 16,
        compile_path = packer_util.join_paths(
            fn.stdpath("data"),
            "site",
            "lua",
            "packer_compiled.lua"
        ),
    }
})

-- For fresh install, we need to install plugins. Otherwise, we just need to require `packer_compiled.lua`.
if fresh_install then
  -- We can command `PackerSync` here, because only after packer.startup, we can know what plugins to install.
  -- So plugin install should be done after the startup process.
  vim.cmd("PackerSync")
else
  local status, _ = pcall(require, 'packer_compiled')
  if not status then
  vim.notify("Error requiring packer_compiled.lua: run PackerSync to fix!")
  end
end
