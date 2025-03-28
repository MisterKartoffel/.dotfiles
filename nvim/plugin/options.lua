
-- █▀▀ █░░ █▀█ █▄▄ ▄▀█ █░░   █▀ █▀▀ ▀█▀ ▀█▀ █ █▄░█ █▀▀ █▀
-- █▄█ █▄▄ █▄█ █▄█ █▀█ █▄▄   ▄█ ██▄ ░█░ ░█░ █ █░▀█ █▄█ ▄█

local set = vim.opt

set.expandtab = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.termguicolors = true

set.nu = true
set.relativenumber = true
set.showmode = false
set.winborder = "rounded"

set.smartindent = true
set.wrap = false

set.ignorecase = true
set.smartcase = true

set.splitright = true
set.splitbelow = true

set.scrolloff = 8
set.signcolumn = "yes"

set.mouse = "a"
set.inccommand = "split"
set.hlsearch = false
set.incsearch = true
set.clipboard = "unnamedplus"

set.swapfile = false

vim.cmd("colorscheme catppuccin")
