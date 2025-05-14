return {
    "nvim-treesitter/nvim-treesitter",
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    build = ":TSUpdate",
    opts = {
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = { enable = true, },
        vim.filetype.add({
            pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
            pattern = { [".*/hypr/hyprland/.*%.conf"] = "hyprlang" },
        }),
    },
}
