
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

-- Vanilla Neovim {{{
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
map("n", "<leader>w", ":w<CR>", { desc = "Save current buffer" })
map("n", "<leader>q", ":wqa<CR>", { desc = "Save and quit all buffers" })
-- }}}

-- fzf-lua {{{
map("n", "<leader>ff", ":FzfLua files<CR>", { desc = "[F]ind [f]ile in CWD" })
map("n", "<leader>fr", ":FzfLua oldfiles<CR>", { desc = "[F]ind [r]ecently opened files" })
map("n", "<leader>fg", ":FzfLua live_grep_native<CR>", { desc = "[F]ind string in CWD with [g]rep" })
map("n", "<leader>fh", ":FzfLua helptags<CR>", { desc = "[F]ind string in [h]elp tags" })
map("n", "<leader>fm", ":FzfLua manpages<CR>", { desc = "[F]ind page in [m]anpages" })
map("n", "<leader>fc", ":FzfLua files cwd=$XDG_CONFIG_HOME/nvim/<CR>", { desc = "[F]ind files in [N]eovim configuration directory" })
-- }}}

-- Lazygit {{{
map("n", "<leader>gl", ":LazyGit<CR>", { desc = "Open current [g]it repository in [L]azyGit" })
-- }}}

-- LSP and None-LS {{{
map("n", "<leader>lh", vim.lsp.buf.hover, { desc = "Display [L]SP [h]over info about symbol under cursor" })
map("n", "<leader>ld", vim.lsp.buf.definition, { desc = "Jump to [L]SP [d]efinition for symbol under cursor" })
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Displays [L]SP [a]ctions for annotation under cursor" })
map("n", "<leader>lf", vim.lsp.buf.format, { desc = "[L]SP auto[f]ormatting" })
-- }}}

-- Markview {{{
map("n", "<leader>mt", ":Markview<CR>", { desc = "[M]arkview [t]oggle" })
-- }}}

-- Which-key {{{
map("n", "<leader>?", function()
    require("which-key").show({ global = true })
end, { desc = "Show keymaps" })
--}}}

-- Yazi {{{
map("n", "<leader>e", ":Yazi<CR>", { desc = "Open Yazi file [e]xplorer" })
-- }}}
