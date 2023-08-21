local opt = vim.opt

-- use Bash
opt.shell = "/bin/bash"

-- encoding
opt.encoding = "utf-8"

-- proper colours
opt.termguicolors = true

-- default update time is 4000ms = 4s, prefer shorter
opt.updatetime = 200

-- mouse (for when I need to show people code)
opt.mouse = { a = true }

-- use system clipboard
opt.clipboard = "unnamedplus"


-- searching
opt.ignorecase = true
opt.smartcase = true

-- undo file
if vim.fn.has("linux") then
  opt.undodir = vim.env.HOME .. "/.vim/undodir"
else
  opt.undodir = "/Users/" .. vim.env.USER .. "/.vim/undodir"
end
opt.undofile = true

opt.swapfile = false

-- nice tabs
local indent = 4
opt.expandtab = true
opt.shiftwidth = indent
opt.smartindent = true
opt.tabstop = indent
opt.softtabstop = indent
opt.shiftround = true

-- stop autocompletion on every key press
opt.completeopt = { "menuone", "noinsert", "noselect" }

-- allow background buffers
opt.hidden = true

-- nicer joins
opt.joinspaces = false

-- line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"

-- cursor line highlighting
opt.cursorline = true

-- line wrap.
opt.wrap = false

-- window splits
opt.splitbelow = true
opt.splitright = true

-- space for displaying messages
opt.cmdheight = 1

-- Don't need to see which mode I'm in
opt.showmode = false

-- start scrolling window when we reach given offset
opt.scrolloff = 6

opt.list = true
opt.listchars = {
  eol = "↲",
  tab = "» ",
  conceal = "┊",
  nbsp = "␣",
}
opt.colorcolumn = "99999"

vim.g.c_syntax_for_h = 1
