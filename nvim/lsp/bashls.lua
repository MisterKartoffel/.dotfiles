return {
    cmd = { "bash-language-server", "start", },
    filetypes = { "bash", "sh", "zsh", },
    settings = {
        bashIde = {
            globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
            shellcheckArguments = {
                "-o", "add-default-case",
                "-o", "avoid-nullary-conditions",
                "-o", "deprecate-which",
                "-o", "quote-safe-variables",
                "-o", "require-double-brackets",
                "-o", "require-variable-braces",
            },
            shfmt = { caseIndent = true, },
        },
    },
}
