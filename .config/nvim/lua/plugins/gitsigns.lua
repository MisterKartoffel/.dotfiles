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
            current_line_blame_opts = { delay = 100, },

            on_attach = function(bufnr)
                local function map(mode, lhs, rhs, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, lhs, rhs, opts)
                end

                -- Navigation
                map("n", "<leader>gn", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "<leader>gn", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end, { desc = "Jump to next hunk" })

                map("n", "<leader>gp", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "<leader>gp", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end, { desc = "Jump to previous hunk" })

                -- Actions
                map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage current hunk" })
                map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset current hunk" })
                map("v", "<leader>gs", function() gitsigns.stage_hunk { vim.fn.line("."), vim.fn.line("v")} end, { desc = "Stage currently selected hunk" })
                map("v", "<leader>gr", function() gitsigns.reset_hunk { vim.fn.line("."), vim.fn.line("v")} end, { desc = "Reset currently selected hunk" })
                map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage current buffer" })
                map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset current buffer" })
                map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo last staged hunk" })
                map("n", "<leader>gv", gitsigns.preview_hunk, { desc = "Preview current hunk" })
                map("n", "<leader>gb", function() gitsigns.blame_line { full = true } end, { desc = "View current line blame" })
                map("n", "<leader>gd", gitsigns.diffthis, { desc = "Open split view diff" })

                -- Lazygit
                map("n", "<leader>gl", function() Snacks.lazygit.open() end, { desc = "Open Lazygit" })

                -- Text object
                map({"o", "x"}, "<leader>gi", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Visually select current hunk" })
            end
        })
    end,
}
