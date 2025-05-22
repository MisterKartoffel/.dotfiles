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
                local nmap = require("utils").nmap
                local vmap = require("utils").vmap

                -- Snacks pickers
                ---@diagnostic disable: undefined-global
                nmap("gps", function()
                    Snacks.picker.git_status()
                end, { desc = "Show status for current working tree" })

                nmap("gpd", function()
                    Snacks.picker.git_diff()
                end, { desc = "Show diff between HEAD and working tree" })

                nmap("gpl", function()
                    Snacks.picker.git_log_file()
                end, { desc = "Browse logs for current buffer" })

                vmap("gpl", function()
                    Snacks.picker.git_log_line()
                end, { desc = "Browse logs for current line" })

                -- Navigation
                nmap("gsp", function()
                    gitsigns.nav_hunk("prev")
                end, { desc = "Jump to previous hunk" })

                nmap("gsn", function()
                    gitsigns.nav_hunk("next")
                end, { desc = "Jump to next hunk" })

                -- Actions
                nmap("gss", gitsigns.stage_hunk, { desc = "Stage current hunk" })
                nmap("gsr", gitsigns.reset_hunk, { desc = "Reset current hunk" })
                vmap("gss", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Stage currently selected hunk" })
                vmap("gsr", function()
                    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Reset currently selected hunk" })
                nmap("gsS", gitsigns.stage_buffer, { desc = "Stage current buffer" })
                nmap("gsR", gitsigns.reset_buffer, { desc = "Reset current buffer" })
                nmap("gsv", gitsigns.preview_hunk_inline, { desc = "Preview current hunk" })
                nmap("gsb", function()
                    gitsigns.blame_line({ full = true })
                end, { desc = "View current line blame" })
                nmap("gsd", gitsigns.diffthis, { desc = "Open split view diff" })

                -- Text object
                map({ "o", "x" }, "gsi", ":<C-U>Gitsigns select_hunk<CR>",
                    { desc = "Visually select current hunk" })
            end,
        })
    end,
}
