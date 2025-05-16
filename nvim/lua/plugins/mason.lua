return {
    "mason-org/mason.nvim",
    event = "VeryLazy",
    opts = {
        ensure_installed = {
            "bashls",
            "jsonls",
            "lua_ls",
            "ruff",
            "shellcheck",
            "taplo",
            "tinymist",
            "typstyle",
        },
    },
}
