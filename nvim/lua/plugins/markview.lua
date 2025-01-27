return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local markview = require("markview")
		local presets = require("markview.presets")

		markview.setup({
			headings = presets.headings.glow,
			checkboxes = presets.checkboxes.nerd,
			tables = presets.tables.rounded,
		})
	end,
}
