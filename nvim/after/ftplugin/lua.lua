local map = require("utils").map

map("n", "sib", "diWa()<Esc>P", { desc = "Surround current WORD in parenthesis" })
map("n", "siB", "diWa{<Space><Space>}<Esc>hP", { desc = "Surround current WORD in curly brackets" })
map("n", "siq", "diWa\"\"<Esc>P", { desc = "Surround current WORD in quotes" })
