return {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },
    opts = {
        ensure_installed = {
            "pyright",
            "mypy",
            "black",
        },
        ui = { border = "rounded" },
    },
}
