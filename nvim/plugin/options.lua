--
-- █▀▀ █░░ █▀█ █▄▄ ▄▀█ █░░   █▀ █▀▀ ▀█▀ ▀█▀ █ █▄░█ █▀▀ █▀
-- █▄█ █▄▄ █▄█ █▄█ █▀█ █▄▄   ▄█ ██▄ ░█░ ░█░ █ █░▀█ █▄█ ▄█
--

-- Saves keystrokes.
local set = vim.opt


-- Basic settings

-- Shows the line number on the left-side column.
-- (default): vim.opt.number = false
set.number = true

-- Changes 'number' to show the line number relative to the cursor position.
-- (default): vim.opt.relativenumber = false
set.relativenumber = true

-- Highlight the line the cursor is currently in.
-- (default): vim.opt.cursorline = false
set.cursorline = true

-- Wraps lines that go beyond the width of the current window.
-- (default): vim.opt.wrap = true
set.wrap = false

-- Minimal number of lines to maintain above and below cursor.
-- (default): vim.opt.scrolloff = 0
set.scrolloff = 8

-- Same as scrolloff, but for side scrolling.
-- (default): vim.opt.sidescrolloff = 0
vim.o.sidescrolloff = 8


-- Indentation

-- Number of spaces equivalent to a <Tab> character.
-- (default): vim.opt.tabstop = 8
set.tabstop = 4

-- Number of spaces a <Tab> counts for when editing.
-- (default): vim.opt.softtabstop = 0
set.softtabstop = 4

-- Number of spaces used for indenting. When 0, uses 'tabstop'.
-- (default): vim.opt.shiftwidth = 8
set.shiftwidth = 4

-- Uses a number of spaces to insert a <Tab> character.
-- (default): vim.opt.expandtab = false
set.expandtab = true

-- Autoindents new line.
-- (default): vim.opt.smartindent = false
set.smartindent = true


-- Search settings

-- Turn search patterns, completions and other searches case-insensitive.
-- (default): vim.opt.ignorecase = false
set.ignorecase = true

-- Override 'ignorecase' if the search pattern contains upercase characters.
-- (default): vim.opt.smartcase = false
set.smartcase = true

-- Highlight all matches for the previous search pattern.
-- (default): vim.opt.hlsearch = true
set.hlsearch = false


-- Visual settings

-- Sets the current colorscheme.
vim.cmd.colorscheme("catppuccin")

-- Enables 24-bit RGB color for the TUI. Requires ISO-8613-3 compatible terminal.
-- (default): vim.opt.termguicolors = false (autodetect)
set.termguicolors = true

-- When and how to draw the signcolumn. Read ':help signcolumn' for specifics.
-- (default): vim.opt.signcolumn = auto
set.signcolumn = "yes"

-- List of options for 'ins-completion'. Read ':help completeopt' for specifics.
-- (default): vim.opt.completeopt = "menu,popup"
set.completeopt = "fuzzy,menuone,popup,noinsert"

-- Displays current mode on the last line if on Insert, Replace or Visual mode.
-- (default): vim.opt.showmode = true
set.showmode = false

-- Defines the default border style of floating windows.
-- (default): vim.opt.winborder = "" (="none")
set.winborder = "rounded"

-- Maximum number of items to show in popup menu.
-- (default): vim.opt.pumheight = 0 (="available space")
set.pumheight = 10

-- Enable pseudo-transparency for the popup menu.
-- (default): vim.opt.pumblend = 0 (="opaque")
set.pumblend = 10

-- Show and configure tab, trailing space and non-breakable space character.
-- (default): vim.opt.list = false
set.list = true

-- (default): vim.opt.listchars = { tab = ">", trail = "-", nbsp = "+" }
set.listchars = { tab = "» ", trail = "·", nbsp = "␣" }


-- File handling

-- Create backup when overwriting file.
-- (default): vim.opt.writebackup = true
vim.opt.writebackup = false

-- Use a swapfile for the buffer.
-- (default): vim.opt.swapfile = true
set.swapfile = false

-- Create a persistent undo file.
-- (default): vim.opt.undofile = false
set.undofile = true
local undodir = os.getenv("XDG_CACHE_HOME") .. "/nvim/undo"
if not vim.fn.isdirectory(undodir) then
    vim.fn.mkdir(undodir, "p")
end
set.undodir = undodir


-- Behavior settings

-- Modify which characters are considered part of a word.
set.iskeyword:append("-")

-- Include subdirectories in search commands.
set.path:append("**")

-- When to enable mouse support. Read ':help mouse' for specifics.
-- (default): vim.opt.mouse = nvi
set.mouse = "a"

-- Set the register to use as clipboard.
-- Scheduled to reduce startup time.
-- (default): vim.opt.clipboard = ""
vim.schedule(function()
    set.clipboard:append("unnamedplus")
end)

-- When on, creating a new split will put the new window right/below the current window.
-- (default): vim.opt.splitright = false; vim.opt.splitbelow = false
set.splitright = true
set.splitbelow = true

-- Show the effects of previewable commands as they're typed.
-- (default): vim.opt.inccommand = nosplit
set.inccommand = "split"

-- Set automatic formatting behavior.
-- (default): vim.opt.formatoptions = "tcqj"
set.formatoptions:remove({ "c", "r", "o" })


-- Folding settings

-- Set the kind of folding to be used.
-- (default): vim.opt.foldmethod = "manual"
set.foldmethod = "expr"

-- Expression to be used when foldmethod is "expr".
-- (default): vim.opt.foldexpr = 0
set.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Set the fold level. Folds with a higher level will be closed.
-- (default): vim.opt.foldlevel = 0
set.foldlevel = 99
