local map = vim.keymap.set

map("n", "<C-j>", "<Esc>")
map("i", "<C-j>", "<Esc>")
map("v", "<C-j>", "<Esc>")
map("s", "<C-j>", "<Esc>")
map("x", "<C-j>", "<Esc>")
map("c", "<C-j>", "<Esc>")
map("o", "<C-j>", "<Esc>")
map("l", "<C-j>", "<Esc>")
map("t", "<C-j>", "<C-\\><C-n>")

map("n", "<leader>e", ':e <C-R>=expand("%:p:h") . "/" <CR>')
map("n", "sw", ":%s/<C-R><C-W>//g<left><left>")
map("n", "<leader><leader>", ":noh<CR>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")

map("n", "H", "0")
map("n", "L", "$")
map("o", "H", "0")
map("o", "L", "$")
map("n", "<leader>T", "<cmd>terminal<CR>", { desc = "terminal" })
