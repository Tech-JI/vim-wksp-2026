local opt = vim.opt

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

opt.termguicolors = true
opt.background = "dark"
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.ruler = true
opt.signcolumn = "yes"
opt.laststatus = 3
opt.cmdheight = 1
opt.updatetime = 250
opt.timeoutlen = 300
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.wrapscan = false
opt.incsearch = true
opt.hlsearch = true
opt.errorbells = false
opt.visualbell = false
opt.hidden = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.splitright = true
opt.splitbelow = true
opt.foldenable = false
opt.foldcolumn = "0"

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = true,
  float = { border = "rounded" },
})

vim.cmd("language C")
