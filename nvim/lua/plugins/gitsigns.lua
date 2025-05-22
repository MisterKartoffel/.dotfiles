return {
    "lewis6991/gitsigns.nvim",
    event = {
        "BufReadPre",
        "BufNewFile",
    },

    config = function()
        local gitsigns = require("gitsigns")

        gitsigns.setup({
            current_line_blame = true,
            current_line_blame_opts = { delay = 100 },

            on_attach = function()
                local map = require("utils").map

                -- Snacks pickers
                map("n", "gps", function()
                    Snacks.picker.git_status()
                end, { desc = "Show status for current working tree" })

                map("n", "gpd", function()
                    Snacks.picker.git_diff()
                end, { desc = "Show diff between HEAD and working tree" })

                map("n", "gpl", function()
                    Snacks.picker.git_log_file()
                end, { desc = "Browse logs for current buffer" })

                map("v", "gpl", function()
                    Snacks.picker.git_log_line()
                end, { desc = "Browse logs for current line" })

                -- Navigation
                map("n", "gsp", function()
                    gitsigns.nav_hunk("prev")
                end, { desc = "Jump to previous hunk" })

                map("n", "gsn", function()
                    gitsigns.nav_hunk("next")
                end, { desc = "Jump to next hunk" })

                -- Actions
                map("n", "gss", gitsigns.stage_hunk, { desc = "Stage current hunk" })
                map("n", "gsr", gitsigns.reset_hunk, { desc = "Reset current hunk" })
                map("v", "gss", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Stage currently selected hunk" })
                map("v", "gsr", function()
                    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Reset currently selected hunk" })
                map("n", "gsS", gitsigns.stage_buffer, { desc = "Stage current buffer" })
                map("n", "gsR", gitsigns.reset_buffer, { desc = "Reset current buffer" })
                map("n", "gsv", gitsigns.preview_hunk_inline, { desc = "Preview current hunk" })
                map("n", "gsb", function()
                    gitsigns.blame_line({ full = true })
                end, { desc = "View current line blame" })
                map("n", "gsd", gitsigns.diffthis, { desc = "Open split view diff" })

                -- Text object
                map({ "o", "x" }, "gsi", ":<C-U>Gitsigns select_hunk<CR>",
                    { desc = "Visually select current hunk" })
            end,
        })
    end,
}
