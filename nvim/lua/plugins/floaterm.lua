return {
    "nvzone/floaterm",
    dependencies = "nvzone/volt",
    cmd = "FloatermToggle",
    opts = {
        border = true,
        terminals = {
            { name = "Terminal", },
        },
    },
    keys = {
        { "<leader>t", ":FloatermToggle<CR>", desc = "Open floating terminal window", },
    },
}
