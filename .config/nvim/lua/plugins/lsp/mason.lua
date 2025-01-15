return {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },
    opts = {
        ui = { border = "rounded", },
    },
}
