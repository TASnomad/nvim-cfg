-- Change fillchars for folding, vertical split, end of buffer, and message separator
vim.opt.fillchars = {
    fold = " ",
    vert = "│",
    eob = " ",
    msgsep = "‾"
}

-- Split window below/right when creating horizontal/vertical windows
vim.o.splitbelow = true
vim.o.splitright = true

-- Time in milliseconds to wait for a mapped sequence to complete,
-- see https://unix.stackexchange.com/q/36882/221410 for more info
vim.o.timeoutlen = 500
-- For CursorHold events
vim.o.updatetime = 500

-- Clipboard settings, always use clipboard for all delete, yank, change, put
-- operation, see https://stackoverflow.com/q/30691466/6064933
if vim.fn.empty(vim.fn['provider#clipboard#Executable']()) == 0 then
    vim.o.clipboard = "unnamedplus"
end

-- Disable creating swapfiles, see https://stackoverflow.com/q/821902/6064933
vim.o.swapfile = false

-- Ignore file and dir name cases in cmd-completion
vim.opt.wildignore:append { "*.o", "*.obj", "*.dylib", "*.bin", "*.dll", "*.exe" }
vim.opt.wildignore:append { "*/.git/*", "*/.svn/*", "*/__pycache__/*", "*/build/**" }
vim.opt.wildignore:append { "*.jpg", "*.png", "*.jpeg", "*.bmp", "*.gif", "*.tiff", "*.svg", "*.ico" }
vim.opt.wildignore:append { "*.pyc", "*.pkl" }
vim.opt.wildignore:append { "*.DS_Store" }
vim.opt.wildignore:append { "*.aux", "*.bbl", "*.blg", "*.brf", "*.fls", "*.fdb_latexmk", "*.synctex.gz", "*.xdv" }
vim.o.wildignorecase = true

-- Set up backup directory
vim.o.backupdir = vim.fn.expand(vim.fn.stdpath('data') .. '/backup//')
-- Skip backup for patterns in option wildignore
vim.o.backupskip = vim.o.wildignore
-- create backup for files
vim.o.backup = true
-- copy the original file to backupdir and overwrite it
vim.o.backupcopy = "yes"

-- General tab settings
vim.o.tabstop = 4      -- number of visual spaces per TAB
vim.o.softtabstop = 4  -- number of spaces in tab when editing
vim.o.shiftwidth = 4   -- number of spaces to use for autoindent
vim.o.expandtab = true -- expand tab to spaces so that tabs are spaces

-- Minimum lines to keep above and below cursor when scrolling
vim.o.scrolloff = 3

-- Use mouse to select and resize windows, etc.
vim.o.mouse = "nic"
vim.o.mousemodel = "popup"

-- Set matching pairs of characters and highlight matching brackets
vim.opt.matchpairs:append { "<:>", "「:」", "『:』", "【:】", "“:”", "‘:’", "《:》" }

-- Show line number and relative line number
vim.o.number = true         -- Enable mouse in several model
vim.o.relativenumber = true -- Set the behaviour of mouse

-- Ignore case in general, but
-- become case-sensitive when uppercase is present
vim.o.ignorecase = true
vim.o.smartcase = true

-- File and script encoding settings for vim
vim.opt.fileencoding = "utf-8"
vim.o.fileencodings = ""
vim.opt.fileencodings:append {
    "ucs-bom",
    "utf-8",
    "cp936",
    "gb18030",
    "big5",
    "euc-jp",
    "euc-kr",
    "latin1"
}

-- Break line at predefined characters
vim.o.linebreak = true

-- Character to show before the lines that have been soft-wrapped
vim.o.showbreak = "↪"

-- List all matches and complete till longest common string
vim.o.wildmode = "list:longest"

-- Disable showing current mode on command line since statusline plugins can show it.
vim.o.showmode = false

-- File formats to use for new files
vim.o.fileformats = "unix,dos"

-- Ask for confirmation when handling unsaved or read-only files
vim.o.confirm = true

-- Do not use visual and error bells
vim.o.visualbell = true
vim.o.errorbells = false

-- The number of command and search history to keep
vim.o.history = 500

-- Use list mode and customized listchars
vim.opt.listchars = {
    tab = "▸ ",
    extends = "❯",
    precedes = "❮",
    nbsp = "␣"
}

vim.o.title = true
vim.o.titlestring = "%{utils#Get_titlestr()}"

-- Persistent undo even after you close a file and re-open it
vim.o.undofile = true

-- Do not show "match xx of xx" and other messages during auto-completion
-- Do not show search match count on bottom right (seriously, I would strain my
-- neck looking at it). Using plugins like vim-anzu or nvim-hlslens is a better
-- choice, IMHO.
-- Disable showing intro message (:intro)
vim.o.shortmess = vim.o.shortmess .. "cSI"

-- Completion behaviour
--
-- Auto select the first completion entry
-- Show menu even if there is only one item
vim.opt.completeopt:append { "noinsert", "menuone" }
-- Disable the preview window
vim.opt.completeopt:remove { "preview" }

-- Maximum number of items to show in popup menu
vim.o.pumheight = 10
-- Pseudo transparency for completion menu
vim.o.pumblend = 10
-- Pseudo transparency for floating window
vim.o.winblend = 0

--  Spell languages
vim.opt.spell = true
vim.opt.spelllang = "en,cjk"
-- Show 9 spell suggestions at most
vim.opt.spellsuggest:append { "9" }

-- Insert mode key word completion setting
vim.opt.complete:append { "kspell" }
vim.opt.complete:remove { "w", "b", "u", "t" }

-- Align indent to next multiple value of shiftwidth. For its meaning,
-- see http://vim.1045645.n5.nabble.com/shiftround-option-td5712100.html
vim.opt.shiftround = true

-- Virtual edit is useful for visual block edit
vim.opt.virtualedit = "block"

-- Correctly break multi-byte characters such as CJK,
-- see https://stackoverflow.com/q/32669814/6064933
vim.opt.formatoptions:append { "m", "M" }

-- Tilde (~) is an operator, thus must be followed by motions like `e` or `w`.
vim.opt.tildeop = true

-- Text after this column number is not highlighted
vim.o.synmaxcol = 200
vim.o.startofline = false

-- External program to use for grep command
if vim.fn.executable('rg') == 1 then
    vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'
    vim.o.grepformat = '%f:%l:%c:%m'
end

-- Enable true color support. Do not set this option if your terminal does not
-- support true colors! For a comprehensive list of terminals supporting true
-- colors, see https://github.com/termstandard/colors and https://gist.github.com/XVilka/8346728
vim.o.termguicolors = true

-- Set up cursor color and shape in various mode, ref:
-- https://github.com/neovim/neovim/wiki/FAQ#how-to-change-cursor-color-in-the-terminal
vim.opt.guicursor:append { "n-v-c:block-Cursor/lCursor", "i-ci-ve:ver25-Cursor2/lCursor2", "r-cr:hor20", "o:hor20" }

vim.o.signcolumn = "auto:2"

-- Remove certain character from file name pattern matching
vim.opt.isfname:remove { "=", "," }

-- Diff options
vim.o.diffopt = ""
vim.opt.diffopt:append {
    "vertical",  -- show diff in vertical position
    "filler",    -- show filler for deleted lines
    "closeoff",  -- turn off diff when one file window is closed
    "context:3", -- context for diff
    "internal",
    "indent-heuristic",
    "algorithm:histogram"
}

-- Do no wrap
vim.o.wrap = false
