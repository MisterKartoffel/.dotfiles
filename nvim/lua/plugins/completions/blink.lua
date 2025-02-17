return {
	"saghen/blink.cmp",
	event = "VeryLazy",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"L3MON4D3/LuaSnip",
		"xzbdmw/colorful-menu.nvim",
		"folke/lazydev.nvim",
		"saghen/blink.cmp",
	},
	version = "*",
	opts = {
		keymap = {
			preset = "none",
			["<Tab>"] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.accept()
					else
						return cmp.select_and_accept()
					end
				end,
				"snippet_forward",
				"fallback",
			},
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<A-c>"] = { "hide_documentation", "show_documentation", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
		},
		completion = {
			menu = {
				draw = {
					columns = {
						{ "kind_icon" },
						{ "label", gap = 1 },
					},
					components = {
						label = {
							text = function(ctx)
								return require("colorful-menu").blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require("colorful-menu").blink_components_highlight(ctx)
							end,
						},
					},
					treesitter = { "lsp" },
				},
				border = "single",
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				window = { border = "single" },
			},
			keyword = { range = "full" },
			ghost_text = { enabled = true },
		},
		snippets = { preset = "luasnip" },
		sources = {
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
			default = {
				"lazydev",
				"lsp",
				"snippets",
				"buffer",
				"path",
			},
			per_filetype = {
				markdown = { "buffer", "path" },
			},
		},
		cmdline = {
			sources = function()
				local type = vim.fn.getcmdtype()
				if type == "/" or type == "?" then
					return { "buffer" }
				end
				if type == ":" or type == "@" then
					return { "cmdline" }
				end
				return {}
			end,
		},
		signature = { enabled = true },
	},
}
