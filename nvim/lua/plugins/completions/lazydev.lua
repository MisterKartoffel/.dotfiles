return {
    "folke/lazydev.nvim",
    lazy = true,
    opts = {
        library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    },
}
