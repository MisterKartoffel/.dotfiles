local map = require("utils").map

map("n", "sib", "viWdi()<Esc>P", { desc = "Surround current word in parenthesis" })
map("n", "siB", "viWdi{<Space><Space>}<Esc>hP", { desc = "Surround current word in curly brackets" })
map("n", "siq", "viWdi\"\"<Esc>P", { desc = "Surround current word in quotes" })
map("n", "sif", "viWdi()<Esc>PF(ifunction<Esc>", { desc = "Surround current argument (WORD) in a function call" })
