function _G.get_oil_winbar()
    local path = vim.fn.expand("%")
    path = path:gsub("oil://", "")

    return vim.fn.fnamemodify(path, ":~")
end

return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", },
    lazy = false,
    opts = {
        delete_to_trash = true,
        watch_for_changes = true,
        view_options = { show_hidden = true, },
        win_options = { winbar = "%!v:lua.get_oil_winbar()", },
        keymaps = {
            ["<C-c>"] = { "actions.close", mode = "n", opts = { exit_if_last_buf = true, }, },
            ["<C-v>"] = { "actions.select", mode = "n", opts = { vertical = true, }, },
            ["<C-s>"] = { "actions.select", mode = "n", opts = { horizontal = true, }, },
            ["<C-t>"] = { "actions.select", mode = "n", opts = { tab = true, }, },

            ["gd"] = { "actions.cd", mode = "n", },

            ["<C-h>"] = false, -- use <C-s> instead, as in vanilla neovim
            ["<CR>"] = false,  -- gf, see comment above
            ["`"] = false,     -- gd
            ["~"] = false,     -- gd
        },
    },
    keys = {
        { "-", ":Oil<CR>", desc = "Open parent directory in Oil", },
    },
}
