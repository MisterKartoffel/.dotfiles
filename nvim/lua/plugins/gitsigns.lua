return {
    "lewis6991/gitsigns.nvim",
    event = {
        "BufReadPre",
        "BufNewFile",
    },

    config = function()
        local gitsigns = require("gitsigns")

        gitsigns.setup({
            on_attach = function()
                local map = require("utils").map

                -- Navigation
                map("n", "[g", function() gitsigns.nav_hunk("prev") end,
                    { desc = "Jump to previous hunk" })
                map("n", "]g", function() gitsigns.nav_hunk("next") end,
                    { desc = "Jump to next hunk" })

                -- Actions
                map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage current hunk" })
                map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset current hunk" })
                map("v", "<leader>gs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
                    { desc = "Stage currently selected hunk" })
                map("v", "<leader>gr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
                    { desc = "Reset currently selected hunk" })
                map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage current buffer" })
                map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset current buffer" })
                map("n", "<leader>gv", gitsigns.preview_hunk_inline, { desc = "Preview current hunk" })
            end,
        })
    end,
}
