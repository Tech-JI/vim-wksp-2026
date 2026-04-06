local map = vim.keymap.set

local function toggle_fold()
  local line_number = vim.fn.line(".")
  local fold_status = vim.fn.foldclosed(line_number)
  if fold_status < 0 then
    vim.cmd("normal! zc")
  else
    vim.cmd("normal! zO")
  end
end

local function surround_selected_text(sign)
  local escaped = vim.fn.escape(sign, [[\]])
  vim.cmd(string.format([[silent '<,'>s/\%%V.\{-}\%%V./%s&%s/]], escaped, escaped))
end

map("n", "<S-Space>", toggle_fold, { desc = "Toggle fold" })
map("n", "`k", "<C-w>+", { silent = true, desc = "Resize window taller" })
map("n", "`j", "<C-w>-", { silent = true, desc = "Resize window shorter" })
map("n", "`l", "<C-w>>", { silent = true, desc = "Resize window wider" })
map("n", "`h", "<C-w><", { silent = true, desc = "Resize window narrower" })
map("n", "<S-h>", "<C-w>h", { silent = true, desc = "Move to left window" })
map("n", "<S-l>", "<C-w>l", { silent = true, desc = "Move to right window" })
map("n", "\\n", "<cmd>set number!<cr>", { silent = true, desc = "Toggle line numbers" })
map("n", ",/", "<cmd>set nohlsearch<cr>", { silent = true, desc = "Clear search highlight" })
map("n", "<F3>", "<cmd>belowright term<cr>", { desc = "Open terminal" })
map("n", "<space>e", vim.diagnostic.open_float, { silent = true, desc = "Line diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { silent = true, desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { silent = true, desc = "Next diagnostic" })
map("n", "<space>q", vim.diagnostic.setloclist, { silent = true, desc = "Diagnostics to loclist" })
map("v", "(", "s()<Esc>P", { silent = true, desc = "Wrap with parentheses" })
map("v", "[", "s[]<Esc>P", { silent = true, desc = "Wrap with brackets" })
map("v", "{", "s{}<Esc>P", { silent = true, desc = "Wrap with braces" })
map("x", "<leader>sd", function()
  surround_selected_text(vim.fn.input("Sign: "))
end, { silent = true, desc = "Surround selection" })
map("n", "<leader>w", "<cmd>write<cr>", { silent = true, desc = "Write buffer" })
map("n", "<leader>qq", "<cmd>qa<cr>", { silent = true, desc = "Quit all" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    map("i", "$", "$$<Esc>i", opts)
    map("i", "^", "^{}<Left>", opts)
    map("i", "_", "_{}<Left>", opts)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    map("i", "<C-b>", "****<Esc>i<Left>", opts)
    map("i", "^", "^{}<Left>", opts)
    map("i", "_", "_{}<Left>", opts)
    map("x", "<C-f>", "xi$$<Esc>hp", opts)
  end,
})
