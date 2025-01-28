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
            "stylua",
            "shfmt",
            "bashls",
            "shellcheck",
            "lua_ls",
            "vimls",
        },
        ui = { border = "rounded" },
    },
}
