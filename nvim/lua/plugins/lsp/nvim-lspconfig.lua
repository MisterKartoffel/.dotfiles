return {
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            lua_ls = {},
            bashls = {},
            vimls = {},
            marksman = {},
            yamlls = {},
            cssls = {},
        },
    },

    config = function(_, opts)
        local lspconfig = require("lspconfig")
        for server, config in pairs(opts.servers) do
            config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
            lspconfig[server].setup(config)
        end
    end,
}
