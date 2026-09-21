local opt = vim.opt

--Tab/Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.wrap = false

-- Search 
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- Appearance
opt.number = true
opt.relativenumber = false
opt.termguicolors = true
-- opt.colorcolumn = '100'
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.scrolloff = 10
opt.completeopt = "menuone,noinsert,noselect"
opt.cursorline = true

-- Behavior
opt.hidden = true
opt.updatetime = 300
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.undofile = true
opt.backspace = "indent,eol,start"
opt.splitright = true
opt.splitbelow = true
opt.autochdir = false
opt.iskeyword:append("-")
opt.iskeyword:append("_")
opt.mouse:append('a')
opt.clipboard:append("unnamedplus")
opt.modifiable=true
-- opt.guicursor = "n-v-c:block,i-ci-ve:lCursor,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
-- Solid block cursor in every mode. The default (i-ci-ve:ver25) draws insert mode
-- as a 25%-width bar, which is hard to spot against the dark theme.
--
-- The trailing "Cursor" names the highlight group whose colour nvim sends to the
-- terminal via OSC 12; without it the terminal keeps its own default cursor
-- colour (green here). That suffix is what actually fixes visibility.
--
-- blinkon0 is already nvim's default for every mode except t:, so it only
-- documents intent here. The explicit t: part restores nvim's default terminal
-- cursor, which an "a:"-only value would otherwise drop -- keeping terminal
-- buffers visually distinct from file buffers.
opt.guicursor = "a:block-blinkon0-Cursor,t:block-blinkon500-blinkoff500-TermCursor"
opt.encoding = "UTF-8"
opt.showmode = false

-- folds
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
