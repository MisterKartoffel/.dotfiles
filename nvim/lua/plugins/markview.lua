return {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },

    config = function()
        local markview = require("markview")
        local presets = require("markview.presets")

        markview.setup({
            checkboxes = presets.checkboxes.nerd,
            headings = presets.headings.simple,
        })
    end
}
