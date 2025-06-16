-- Show user:group of files in status bar
Status:children_add(function()
    local h = cx.active.current.hovered
    if h == nil then
        return ""
    end

    return ui.Line({
        ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"), ":",
        ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"), " ",
    })
end, 500, Status.RIGHT)

-- Show symlink in status bar
Status:children_add(function(self)
    local h = self._current.hovered
    if h and h.link_to then
        return " -> " .. tostring(h.link_to)
    else
        return ""
    end
end, 3300, Status.LEFT)

-- Sync yanked files across Yazi sessions
require("session"):setup({
    sync_yanked = true,
})

-- Change pane ratio when opened inside of Neovim
require("neovim"):setup({
    ratio = { 0, 1, 4 },
})
