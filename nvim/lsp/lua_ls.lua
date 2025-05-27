return {
    cmd = { "lua-language-server", },
    root_markers = { ".luarc.json", ".luarc.jsonc", },
    filetypes = { "lua", },
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace",
                keywordSnippet = "Replace",
            },
            runtime = { version = "LuaJIT", },
            path = {
                "lua/?.lua",
                "lua/?/init.lua",
            },
            hint = { enable = true, },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    "${3rd}/luv/library",
                    "${3rd}/busted/library",
                },
            },
        },
    },
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath("config")
                and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
            then
                return
            end
        end
    end
}
