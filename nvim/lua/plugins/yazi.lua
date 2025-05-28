return {
    "mikavilpas/yazi.nvim",
    cmd = { "Yazi", },
    opts = {
        open_for_directories = true,
        open_multiple_tabs = true,
        keymaps = {
            show_help = "<F1>",
            open_file_in_vertical_split = "<c-v>",
            open_file_in_horizontal_split = "<c-h>",
            open_file_in_tab = "<c-t>",
            grep_in_directory = "<c-g>",
            cycle_open_buffers = "<tab>",
            copy_relative_path_to_selected_files = "<c-y>",
            send_to_quickfix_list = "<c-q>",
            change_working_directory = "<c-\\>",
            open_and_pick_window = "<c-o>",
            replace_in_directory = "<c-r>",
        },
        integrations = {
            grep_in_directory = function(directory)
                Snacks.picker.grep({ dirs = { directory } })
            end,
        },
    },
    keys = {
        { mode = { "n", "v" }, "<leader>e", ":Yazi<CR>", desc = "Open yazi on the CWD" },
    },
}
