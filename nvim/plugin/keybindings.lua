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

-- Snacks.picker
---@diagnostic disable: undefined-global
nmap("<leader>fc", function()
    Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[F]ind files in [n]eovim configuration directory" })
nmap("<leader>fg", function()
    Snacks.picker.grep()
end, { desc = "[F]ind string in CWD with [g]rep" })
nmap("<leader>fh", function()
    Snacks.picker.help()
end, { desc = "[F]ind string in [h]elp tags" })
nmap("<leader>fk", function()
    Snacks.picker.keymaps()
end, { desc = "[F]ind [k]eymaps" })
nmap("<leader>fl", function()
    Snacks.picker.lines()
end, { desc = "[F]ind [l]ines in current buffer" })
nmap("<leader>fm", function()
    Snacks.picker.man()
end, { desc = "[F]ind page in [m]anpages" })
nmap("<leader>fn", function()
    Snacks.picker.notifications()
end, { desc = "[F]ind [n]otifications" })
nmap("<leader>fo", function()
    Snacks.picker.loclist()
end, { desc = "[F]ind item in l[o]cation list" })
nmap("<leader>fp", function()
    Snacks.picker()
end, { desc = "[F]ind [p]icker" })
nmap("<leader>fq", function()
    Snacks.picker.qflist()
end, { desc = "[F]ind item in [q]uickfix list" })
nmap("<leader>fs", function()
    Snacks.picker.smart()
end, { desc = "[F]ind among open buffers, recent files and files in CWD" })

-- Snacks.scratch
nmap("<leader>st", function()
    Snacks.scratch.open()
end, { desc = "[S]cratch buffer [t]oggle" })
nmap("<leader>ss", function()
    Snacks.scratch.select()
end, { desc = "[S]cratch buffer [s]elect" })

-- Snacks.terminal
nmap("<leader>t", function()
    Snacks.terminal.toggle()
end, { desc = "Toggle terminal" })

-- Which-key
nmap("<leader>?", function()
    require("which-key").show({ global = true })
end, { desc = "Show keymaps" })

-- Yazi
nmap("<leader>e", ":Yazi<CR>", { desc = "Open Yazi file [e]xplorer" })
