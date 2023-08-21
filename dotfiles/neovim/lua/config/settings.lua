local opt = require("utils").opt
local create_augroups = require("utils").nvim_create_augroups

-- use Bash
opt("o", "shell", "/bin/bash")

-- encoding
opt("o", "encoding", "utf-8")

-- proper colours
opt("o", "termguicolors", true)

-- default update time is 4000ms = 4s, prefer shorter
opt("o", "updatetime", 200)

-- mouse (for when I need to show people code)
opt("o", "mouse", "a")

-- use system clipboard
opt("o", "clipboard", "unnamedplus")

-- searching
opt("o", "ignorecase", true)
opt("o", "smartcase", true)

-- undo file
if vim.fn.has("linux") then
  opt("o", "undodir", vim.env.HOME .. "/.vim/undodir")
else
  opt("o", "undodir", "/Users/" .. vim.env.USER .. "/.vim/undodir")
end

opt("b", "undofile", true)

-- swap file
opt("b", "swapfile", false)

-- nice tabs
local indent = 4
opt("b", "expandtab", true)
opt("b", "shiftwidth", indent)
opt("b", "smartindent", true)
opt("b", "tabstop", indent)
opt("b", "softtabstop", indent)
opt("o", "shiftround", true)

-- stop autocompletion on every key press
opt("o", "completeopt", "menuone,noinsert,noselect")

-- allow background buffers
opt("o", "hidden", true)

-- nicer joins
opt("o", "joinspaces", false)

-- line numbers
opt("w", "number", true)
opt("w", "relativenumber", true)
opt("w", "signcolumn", "yes")

-- cursor line highlighting
opt("w", "cursorline", true)

-- line wrap.
opt("w", "wrap", false)

-- window splits
opt("o", "splitbelow", true)
opt("o", "splitright", true)

-- space for displaying messages
opt("o", "cmdheight", 1)

-- Don't need to see which mode I'm in
opt("o", "showmode", false)

-- start scrolling window when we reach given offset
opt("o", "scrolloff", 6)

vim.wo.list = true
vim.opt.listchars = {
  eol = "↲",
  tab = "» ",
  conceal = "┊",
  nbsp = "␣",
}
vim.wo.colorcolumn = "99999"

-- find a better place for these
local file_types =
"javascript,typescript,javascriptreact,typescriptreact,javascript.jsx,typescript.tsx,lua,yaml,java,c,cpp,nix"

create_augroups({
  spacing = {
    { "FileType " .. file_types .. " set shiftwidth=2" },
    { "FileType " .. file_types .. " set tabstop=2" },
    { "FileType " .. file_types .. " set tabstop=2" },
  },
  text_width = {
    { "FileType " .. "markdown" .. " setlocal textwidth=100" },
  }
})



vim.g.c_syntax_for_h = 1
