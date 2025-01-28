local on_attach = function(_, bufnr)
	return { buffer = bufnr }
end

return {
            lua_ls = {
                filetypes = { "lua", },
            },
            pyright = {
                filetypes = { "python", },
            },
            marksman = {},
            bashls = {},
            vimls = {},
            yamlls = {},
            cssls = {},
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
		},
	},

	config = function(_, opts)
		local lspconfig = require("lspconfig")
		for server, config in pairs(opts.servers) do
			config.on_attach = on_attach
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			lspconfig[server].setup(config)
		end
	end,
}
