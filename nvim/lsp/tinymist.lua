---@param command_name string
---@return fun():nil run_tinymist_command, string cmd_name, string cmd_desc
local function create_tinymist_command(command_name, client, bufnr)
    local export_type = command_name:match("tinymist%.export(%w+)")
    local info_type = command_name:match("tinymist%.(%w+)")
    if info_type and info_type:match("^get") then
        info_type = info_type:gsub("^get", "Get")
    end
    local cmd_display = export_type or info_type

    ---@return nil
    local function run_tinymist_command()
        local arguments = { vim.api.nvim_buf_get_name(bufnr) }
        local title_str = export_type and ("Export " .. cmd_display) or cmd_display

        ---@type lsp.Handler
        local function handler(err, res)
            if err then
                return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
            end
            vim.notify(export_type and res or vim.inspect(res), vim.log.levels.INFO)
        end
        if vim.fn.has("nvim-0.11") == 1 then
            return client:exec_cmd({
                title = title_str,
                command = command_name,
                arguments = arguments,
            }, { bufnr = bufnr }, handler)
        else
            return vim.notify("Tinymist commands require Neovim 0.11+", vim.log.levels.WARN)
        end
    end

    ---@type string
    local cmd_name = export_type and ("LspTinymistExport" .. cmd_display) or ("LspTinymist" .. cmd_display)
    local cmd_desc = export_type and ("Export to " .. cmd_display) or ("Get " .. cmd_display)
    return run_tinymist_command, cmd_name, cmd_desc
end

return {
    cmd = { "tinymist", },
    filetypes = { "typst", },
    settings = { formatterMode = "typstyle", },
    on_attach = function(client, bufnr)
        for _, command in ipairs({
            'tinymist.exportSvg',
            'tinymist.exportPng',
            'tinymist.exportPdf',
            'tinymist.exportHtml',
            'tinymist.exportMarkdown',
            'tinymist.exportText',
            'tinymist.exportQuery',
            'tinymist.exportAnsiHighlight',
            'tinymist.getServerInfo',
            'tinymist.getDocumentTrace',
            'tinymist.getWorkspaceLabels',
            'tinymist.getDocumentMetrics',
        }) do
            local cmd_func, cmd_name, cmd_desc = create_tinymist_command(command, client, bufnr)
            vim.api.nvim_buf_create_user_command(0, cmd_name, cmd_func, { nargs = 0, desc = cmd_desc })
        end
    end,
}
