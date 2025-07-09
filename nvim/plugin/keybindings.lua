--
-- █▄▀ █▀▀ █▄█ █▄▄ █ █▄░█ █▀▄ █ █▄░█ █▀▀ █▀
-- █░█ ██▄ ░█░ █▄█ █ █░▀█ █▄▀ █ █░▀█ █▄█ ▄█
--

local map = require("utils").map

-- Vanilla Neovim
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected string down a line and autoindent" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected string up a line and autoindent" })

map("v", "<", "<gv", { desc = "Remove indentation and maintain selection" })
map("v", ">", ">gv", { desc = "Add indentation and maintain selection" })

map("n", "J", "V<Esc>Jgv<Esc>zz", { desc = "Append line below while keeping cursor still" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down and center screen on cursor" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up and center screen on cursor" })

map("n", "<leader><leader>", ":w<CR> :so<CR>", { desc = "Save and source current file" })

-- Lazy and Mason
map("n", "<leader>pl", ":Lazy<CR>", { desc = "Open Lazy.nvim UI" })
map("n", "<leader>pm", ":Mason<CR>", { desc = "Open Mason UI" })
