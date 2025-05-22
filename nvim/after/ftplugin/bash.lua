local nmap = require("utils").nmap

nmap("siB", "eF$a{<Esc>ea}<Esc>", { desc = "Surround current variable in braces" })
nmap("siq", "diWa\"\"<Esc>P", { desc = "Surround current WORD in quotes" })
