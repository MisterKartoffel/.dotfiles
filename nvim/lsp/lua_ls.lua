return {
    cmd = { "lua-language-server", },
    root_markers = { ".luarc.json", ".luarc.jsonc", },
    filetypes = { "lua", },
    settings = {
        Lua = {
            runtime = { version = "LuaJIT", },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
        },
    },
}
