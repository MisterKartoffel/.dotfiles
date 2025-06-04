return {
    "mason-org/mason.nvim",
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            },
        },
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
