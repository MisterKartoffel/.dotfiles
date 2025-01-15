return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
    },

    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        local button = dashboard.button

        -- Header {{{
        dashboard.section.header.val = {
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                     ]],
            [[       ████ ██████           █████      ██                     ]],
            [[      ███████████             █████                             ]],
            [[      █████████ ███████████████████ ███   ███████████   ]],
            [[     █████████  ███    █████████████ █████ ██████████████   ]],
            [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
            [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
            [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
        }
        -- }}}

        -- Buttons {{{
        dashboard.section.buttons.val = {
            button("e", "  ❱ New file", "<CMD>ene <BAR> startinsert <CR>"),
            button("SPC e", "  ❱ Browse filesystem", "<CMD>Yazi<CR>"),
            button("SPC ff", "󰱽  ❱ Find file", "<CMD>FzfLua files<CR>"),
            button("SPC fr", "󱋢  ❱ Recent files", "<CMD>FzfLua oldfiles<CR>"),
            button("s", "  ❱ Settings", "<CMD>cd $HOME/.config/nvim<CR> <CMD>Yazi<CR>"),
            button("q", "󰩈  ❱ Quit Neovim", "<CMD>qa<CR>"),
        }
        -- }}}

        -- Footer {{{
        local function footer()
            local total_plugins = require("lazy").stats().count
            local version = vim.version()
            local nvim_version_info = "   Neovim v" .. version.major .. "." .. version.minor .. "." .. version.patch

            return "  " .. total_plugins .. " plugins" .. nvim_version_info
        end
        dashboard.section.footer.val = footer()
        --}}}

        alpha.setup(dashboard.opts)
        vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])
    end,
}
