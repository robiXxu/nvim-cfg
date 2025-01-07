vim.cmd("syntax on")
vim.cmd("hi! Normal ctermbg=NONE guibg=NONE")
vim.cmd("filetype on")

vim.cmd("filetype plugin on")
vim.cmd("set cc=120")

-- if file was changed, read it again
vim.opt.autoread = true

-- Disable mouse
vim.opt.mouse = ""
vim.cmd("set mouse-=a")

vim.o.termguicolors = true
-- vim.o.background = 'dark'


vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 5

vim.opt.clipboard = "unnamedplus"

vim.o.history = 100

-- Preserve view while jumping
vim.o.jumpoptions = "view"

-- Clipboard - neovim clipboard + OS clipboard = sexy time
vim.o.clipboard = "unnamedplus"

-- show (partial) command in the last line of the screen
vim.o.showcmd = true
-- (default 1) increase number of lines for command-line
vim.o.cmdheight = 1
-- show the line and column number of the cursor position
vim.o.ruler = true
-- last window will have a statusline always
vim.o.laststatus = 2
-- if modelines=0 > no lines are checked for commands
vim.o.modelines = 0
-- show matching brackets when text indicator is over them
vim.o.showmatch = true
-- ignore case when searching
vim.o.ignorecase = true
-- override ignorecase if i'm using Uppercase chars
vim.o.smartcase = true
-- highlight search results
vim.o.hlsearch = true
-- highlight what matches as i type
vim.o.incsearch = true
-- use the appropriate number of spaces to insert a <tab>
vim.o.expandtab = true
--vim.o.cindent = true
-- <Tab> in front of a line inserts blanks according to 'shiftwidth'
vim.o.smarttab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
-- better commandline tab completion
vim.o.wildmode = "list:longest,list:full"
-- splitting a window will put the new window right of the current one.
vim.o.splitright = true
-- show tabline always
vim.o.showtabline = 2
