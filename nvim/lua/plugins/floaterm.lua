return {
    "nvzone/floaterm",
    dependencies = "nvzone/volt",
    cmd = "FloatermToggle",
    opts = {
        mappings = {
            term = function(buf)
                vim.keymap.set("t", "<C-p>", function()
                    require("floaterm.api").cycle_term_bufs("prev")
                end, { buffer = buf })
                vim.keymap.set("t", "<C-n>", function()
                    require("floaterm.api").cycle_term_bufs("next")
                end, { buffer = buf })
            end,
        },
        terminals = {
            { name = "Terminal", },
        },
    },
    keys = {
        {
            "<leader>t",
            ":FloatermToggle<CR>",
            desc = "Toggle floating terminal window"
        },
        {
            "<Esc><Esc>",
            function() require("floaterm").toggle() end,
            mode = "t",
            desc = "Toggle floating terminal window"
        },
    },
}
