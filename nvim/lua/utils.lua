local M = {}

-- Avoids having to continuously call vim.keymap.set() for every keymap
-- Stolen from Bvngee
function M.map(mode, lhs, rhs, opts)
    local default_opts = { silent = true, buffer = 0 }
    if opts then
        vim.tbl_extend("force", default_opts, opts)
    else
        opts = default_opts
    end

    vim.keymap.set(mode, lhs, rhs, opts)
end

function M.unmap(mode, lhs, opts)
    if not opts then
        opts.buffer = 0
    end

    vim.keymap.del(mode, lhs, opts)
end

return M
