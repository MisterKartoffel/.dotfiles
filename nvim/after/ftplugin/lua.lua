local nmap = require("utils").nmap

nmap("sib", "diWa()<Esc>P", { desc = "Surround current WORD in parenthesis" })
nmap("siB", "diWa{<Space><Space>}<Esc>hP", { desc = "Surround current WORD in curly brackets" })
nmap("siq", "diWa\"\"<Esc>P", { desc = "Surround current WORD in quotes" })
