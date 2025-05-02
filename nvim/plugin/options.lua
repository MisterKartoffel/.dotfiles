-- █▀▀ █░░ █▀█ █▄▄ ▄▀█ █░░   █▀ █▀▀ ▀█▀ ▀█▀ █ █▄░█ █▀▀ █▀
-- █▄█ █▄▄ █▄█ █▄█ █▀█ █▄▄   ▄█ ██▄ ░█░ ░█░ █ █░▀█ █▄█ ▄█

-- Saves keystrokes.
local set = vim.o

-- Uses a number of spaces to insert a <Tab> character.
-- (default): vim.o.expandtab = false
set.expandtab = true

-- Number of spaces equivalent to a <Tab> character.
-- (default): vim.o.tabstop = 8
set.tabstop = 4

-- Number of spaces a <Tab> counts for when editing.
-- (default): vim.o.softtabstop = 0
set.softtabstop = 4

-- Number of spaces used for indenting. When 0, uses 'tabstop'.
-- (default): vim.o.shiftwidth = 8
set.shiftwidth = 4

-- Enables 24-bit RGB color for the TUI. Requires ISO-8613-3 compatible terminal.
-- (default): vim.o.termguicolors = false (autodetect)
set.termguicolors = true

-- Shows the line number on the left-side column.
-- (default): vim.o.number = false
set.number = true

-- Changes 'number' to show the line number relative to the cursor position.
-- (default): vim.o.relativenumber = false
set.relativenumber = true

-- Displays current mode on the last line if on Insert, Replace or Visual mode.
-- (default): vim.o.showmode = true
set.showmode = false

-- Defines the default border style of floating windows.
-- (default): vim.o.winborder = "" (="none")
set.winborder = "rounded"

-- Autoindents new line.
-- (default): vim.o.smartindent = false
set.smartindent = true

-- Wraps lines that go beyond the width of the current window.
-- (default): vim.o.wrap = true
set.wrap = false

-- Turn search patterns, completions and other searches case-insensitive.
-- (default): vim.o.ignorecase = false
set.ignorecase = true

-- Override 'ignorecase' if the search pattern contains upercase characters.
-- (default): vim.o.smartcase = false
set.smartcase = true

-- When on, creating a new split will put the new window rigth/below the current window.
-- (default): vim.o.splitright = false; vim.o.splitbelow = false
set.splitright = true
set.splitbelow = true

-- Minimal number of lines to maintain above and below cursor.
-- (default): vim.o.scrolloff = 0
set.scrolloff = 8

-- When and how to draw the signcolumn. Read ':help signcolumn' for specifics.
-- (default): vim.o.signcolumn = auto
set.signcolumn = "yes"

-- When to enable mouse support. Read ':help mouse' for specifics.
-- (default): vim.o.mouse = nvi
set.mouse = "a"

-- Show the effects of previewable commands as they're typed.
-- (default): vim.o.inccommand = nosplit
set.inccommand = "split"

-- Highlight all matches for the previous search pattern.
-- (default): vim.o.hlsearch = true
set.hlsearch = false

-- Set the register to use as clipboard.
-- (default): vim.o.clipboard = ""
set.clipboard = "unnamedplus"

-- Use a swapfile for the buffer.
-- (default): vim.o.swapfile = true
set.swapfile = false

-- List of options for 'ins-completion'. Read ':help completeopt' for specifics.
-- (default): vim.o.completeopt = "menu,popup"
set.completeopt = "fuzzy,menuone,preview,noinsert"

-- Sets the current colorscheme.
vim.cmd.colorscheme("catppuccin")
