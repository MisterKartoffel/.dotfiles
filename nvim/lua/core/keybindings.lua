
-- █▄▀ █▀▀ █▄█ █▄▄ █ █▄░█ █▀▄ █ █▄░█ █▀▀ █▀
-- █░█ ██▄ ░█░ █▄█ █ █░▀█ █▄▀ █ █░▀█ █▄█ ▄█

-- Saves having to define default options for all keymaps, shamelessly stolen from https://github.com/Bvngee/nixconf
local function map(mode, lhs, rhs, opts)
    local default_opts = { silent = true }
    if opts then
        opts = vim.tbl_extend("force", default_opts, opts)
    else
        opts = default_opts
    end
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- Vanilla Neovim
map({ "n", "v", "i" }, "<C-ç>", "<CR>", { desc = "Remaps CTRL+ç to ENTER" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected string down a line and autoindent" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected string up a line and autoindent" })

map("n", "<A-o>", "o<Esc>", { desc = "Create a new line below and stay in normal mode" })
map("n", "<A-O>", "O<Esc>", { desc = "Create a new line above and stay in normal mode" })

map("n", "J", "mzJ`z", { desc = "Append line below while keeping cursor still" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down and center screen on cursor" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up and center screen on cursor" })

map("x", "<leader>p", [["_dP]], { desc = "Paste over selected string while keeping current register" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without copying" })

map("n", "<leader><leader>", ":w<CR> :so<CR>", { desc = "Save and source current file" })
map("n", "<leader>wa", ":wa<CR>", { desc = "Save all buffers" })
map("n", "<leader>wq", ":wqa<CR>", { desc = "Save and quit all buffers" })

map("n", "[q", ":cprev<CR>", { desc = "Go to previous item in quickfix list" })
map("n", "]q", ":cnext<CR>", { desc = "Go to next item in quickfix list" })
map("n", "<leader>qc", ":cclose<CR>", { desc = "Close quickfix list" })

-- Lazy and Mason
map("n", "<leader>pl", ":Lazy<CR>", { desc = "Open Lazy.nvim UI" })
map("n", "<leader>pm", ":Mason<CR>", { desc = "Open Mason UI" })

-- LSP and None-LS
map("n", "<leader>lh", vim.lsp.buf.hover, { desc = "Display [L]SP [h]over info about symbol under cursor" })
map("n", "<leader>ld", vim.lsp.buf.definition, { desc = "Jump to [L]SP [d]efinition for symbol under cursor" })
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Displays [L]SP [a]ctions for annotation under cursor" })
map("n", "<leader>lf", vim.lsp.buf.format, { desc = "[L]SP auto[f]ormatting" })

-- Markview
map("n", "<leader>mt", ":Markview<CR>", { desc = "[M]arkview [t]oggle" })

-- Snacks.picker
map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "[F]ind [f]iles in CWD" })
map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "[F]ind [r]ecently opened files" })
map("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "[F]ind string in CWD with [g]rep" })
map("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "[F]ind string in [h]elp tags" })
map("n", "<leader>fm", function() Snacks.picker.man() end, { desc = "[F]ind page in [m]anpages" })
map("n", "<leader>fk", function() Snacks.picker.keymaps() end, { desc = "[F]ind [k]eymaps" })
map("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "[F]ind files in [N]eovim configuration directory" })
map("n", "<leader>fl", function() Snacks.picker.lines() end, { desc = "[F]ind [l]ines in current buffer" })
map("n", "<leader>fp", function() Snacks.picker() end, { desc = "[F]ind [p]icker" })

-- Snacks.scratch
map("n", "<leader>st", function() Snacks.scratch.open() end, { desc = "[S]cratch buffer [t]oggle" })
map("n", "<leader>ss", function() Snacks.scratch.select() end, { desc = "[S]cratch buffer [s]elect" })

-- Which-key
map("n", "<leader>?", function()
    require("which-key").show({ global = true })
end, { desc = "Show keymaps" })

-- Yazi
map("n", "<leader>e", ":Yazi<CR>", { desc = "Open Yazi file [e]xplorer" })
