--
-- █▄▀ █▀▀ █▄█ █▄▄ █ █▄░█ █▀▄ █ █▄░█ █▀▀ █▀
-- █░█ ██▄ ░█░ █▄█ █ █░▀█ █▄▀ █ █░▀█ █▄█ ▄█
--

local map = require("utils").map
local nmap = require("utils").nmap
local vmap = require("utils").vmap

-- Vanilla Neovim
vmap("J", ":m '>+1<CR>gv=gv", { desc = "Move selected string down a line and autoindent" })
vmap("K", ":m '<-2<CR>gv=gv", { desc = "Move selected string up a line and autoindent" })

nmap("J", "V<Esc>Jgv<Esc>zz", { desc = "Append line below while keeping cursor still" })
nmap("<C-d>", "<C-d>zz", { desc = "Scroll half page down and center screen on cursor" })
nmap("<C-u>", "<C-u>zz", { desc = "Scroll half page up and center screen on cursor" })

map("x", "<leader>p", [["_dP]], { desc = "Paste over selected string while keeping current register" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without copying" })

nmap("<leader><leader>", ":w<CR> :so<CR>", { desc = "Save and source current file" })

-- Lazy and Mason
nmap("<leader>pl", ":Lazy<CR>", { desc = "Open Lazy.nvim UI" })
nmap("<leader>pm", ":Mason<CR>", { desc = "Open Mason UI" })
