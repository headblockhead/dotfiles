vim.opt.autoindent = true
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.tabstop = 2

-- Disable netrw (using nvim-tree instead).
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set termguicolors to enable highlight groups.
vim.opt.termguicolors = true

-- Move the preview screen.
vim.opt.splitbelow = true

-- Make it so that the gutter (left column) doesn't move.
vim.opt.signcolumn = "yes"

-- Set line numbers to be visible all of the time.
vim.opt.number = true

-- Disable mouse control.
vim.cmd("set mouse=")

-- Enable undo and swap file
vim.cmd("set undofile")
vim.cmd("set swapfile")

vim.cmd("set undodir^=$HOME/.vim/undo//")
vim.cmd("set backupdir^=$HOME/.vim/backup//")
vim.cmd("set directory^=$HOME/.vim/swap//")

vim.cmd("au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile")

-- Use system clipboard.
vim.api.nvim_command('set clipboard+=unnamedplus')
