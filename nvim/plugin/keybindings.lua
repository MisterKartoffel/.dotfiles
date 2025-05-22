--
-- █▄▀ █▀▀ █▄█ █▄▄ █ █▄░█ █▀▄ █ █▄░█ █▀▀ █▀
-- █░█ ██▄ ░█░ █▄█ █ █░▀█ █▄▀ █ █░▀█ █▄█ ▄█
--

local map = require("utils").map

-- Vanilla Neovim
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected string down a line and autoindent" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected string up a line and autoindent" })

map("n", "J", "V<Esc>Jgv<Esc>zz", { desc = "Append line below while keeping cursor still" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down and center screen on cursor" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up and center screen on cursor" })

map("x", "<leader>p", [["_dP]], { desc = "Paste over selected string while keeping current register" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without copying" })

map("n", "<leader><leader>", ":w<CR> :so<CR>", { desc = "Save and source current file" })

-- Lazy and Mason
map("n", "<leader>pl", ":Lazy<CR>", { desc = "Open Lazy.nvim UI" })
map("n", "<leader>pm", ":Mason<CR>", { desc = "Open Mason UI" })

-- Markview
map("n", "<leader>mt", ":Markview<CR>", { desc = "[M]arkview [t]oggle" })

-- Snacks.picker
---@diagnostic disable: undefined-global
map("n", "<leader>fc", function()
    Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[F]ind files in [n]eovim configuration directory" })
map("n", "<leader>fg", function()
    Snacks.picker.grep()
end, { desc = "[F]ind string in CWD with [g]rep" })
map("n", "<leader>fh", function()
    Snacks.picker.help()
end, { desc = "[F]ind string in [h]elp tags" })
map("n", "<leader>fk", function()
    Snacks.picker.keymaps()
end, { desc = "[F]ind [k]eymaps" })
map("n", "<leader>fl", function()
    Snacks.picker.lines()
end, { desc = "[F]ind [l]ines in current buffer" })
map("n", "<leader>fm", function()
    Snacks.picker.man()
end, { desc = "[F]ind page in [m]anpages" })
map("n", "<leader>fn", function()
    Snacks.picker.notifications()
end, { desc = "[F]ind [n]otifications" })
map("n", "<leader>fo", function()
    Snacks.picker.loclist()
end, { desc = "[F]ind item in l[o]cation list" })
map("n", "<leader>fp", function()
    Snacks.picker()
end, { desc = "[F]ind [p]icker" })
map("n", "<leader>fq", function()
    Snacks.picker.qflist()
end, { desc = "[F]ind item in [q]uickfix list" })
map("n", "<leader>fs", function()
    Snacks.picker.smart()
end, { desc = "[F]ind among open buffers, recent files and files in CWD" })

-- Snacks.scratch
map("n", "<leader>st", function()
    Snacks.scratch.open()
end, { desc = "[S]cratch buffer [t]oggle" })
map("n", "<leader>ss", function()
    Snacks.scratch.select()
end, { desc = "[S]cratch buffer [s]elect" })

-- Snacks.terminal
map("n", "<leader>tt", function()
    Snacks.terminal.toggle()
end, { desc = "Toggle terminal" })

-- Which-key
map("n", "<leader>?", function()
    require("which-key").show({ global = true })
end, { desc = "Show keymaps" })

-- Yazi
map("n", "<leader>e", ":Yazi<CR>", { desc = "Open Yazi file [e]xplorer" })
