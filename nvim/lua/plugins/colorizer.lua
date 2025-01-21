return {
    "norcalli/nvim-colorizer.lua",
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    opts = {
        "*",
        user_default_options = {
            RRGGBBAA = true,
            css = true,
            css_fn = true,
            mode = "background",
            always_update = true,
        },
    },
}
