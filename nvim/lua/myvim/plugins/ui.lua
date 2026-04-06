local bootstrap = vim.env.MYVIM_BOOTSTRAP == "1"

local function search_result()
  if vim.v.hlsearch == 0 then
    return ""
  end

  local last_search = vim.fn.getreg("/")
  if last_search == "" then
    return ""
  end

  local count = vim.fn.searchcount({ maxcount = 9999 })
  return string.format("%s(%d/%d)", last_search, count.current, count.total)
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
        component_separators = "",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          { "filename", file_status = false, path = 1 },
          "diff",
          { "diagnostics", sources = { "nvim_lsp" } },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { search_result },
        lualine_z = { "%p%%/%L" },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = bootstrap and "VeryLazy" or "BufWinEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { ",1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Buffer 1" },
      { ",2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Buffer 2" },
      { ",3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Buffer 3" },
      { ",4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Buffer 4" },
      { ",5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Buffer 5" },
      { ",6", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "Buffer 6" },
      { ",7", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "Buffer 7" },
      { ",8", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "Buffer 8" },
      { ",9", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "Buffer 9" },
      { ",$", "<cmd>BufferLineGoToBuffer -1<cr>", desc = "Last buffer" },
      { ",gt", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { ",gT", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "<C-Q>", "<cmd>bd<cr>", desc = "Delete buffer" },
    },
    opts = {
      options = {
        numbers = "ordinal",
        close_command = "bdelete",
        right_mouse_command = "bdelete!",
        middle_mouse_command = "bdelete!",
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
          },
        },
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>m", "<cmd>NvimTreeToggle<cr>", desc = "Toggle tree" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      sort_by = "case_sensitive",
      view = { width = 25 },
      renderer = { group_empty = true },
      filters = { dotfiles = true },
      diagnostics = {
        enable = true,
        show_on_dirs = false,
        show_on_open_dirs = true,
      },
    },
  },
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>o", "<cmd>Outline<cr>", desc = "Outline" },
    },
    opts = {
      outline_window = {
        position = "right",
        width = 25,
        relative_width = true,
        focus_on_open = true,
      },
      symbol_folding = {
        autofold_depth = 1,
      },
    },
  },
  {
    "folke/snacks.nvim",
    lazy = bootstrap,
    priority = 900,
    keys = {
      {
        "<leader>b.",
        function()
          require("snacks").bufdelete.delete()
        end,
        desc = "Delete current buffer",
      },
      {
        "<leader>bo",
        function()
          require("snacks").bufdelete.other()
        end,
        desc = "Delete all other buffers",
      },
      {
        "<leader>hs",
        function()
          require("snacks").notifier.show_history()
        end,
        desc = "Show notifications",
      },
      {
        "<leader>n",
        function()
          require("snacks").notifier.hide()
        end,
        desc = "Dismiss notifications",
      },
      {
        "<leader>gb",
        function()
          require("snacks").picker.git_branches()
        end,
        desc = "Git branches",
      },
      {
        "<leader>gl",
        function()
          require("snacks").picker.git_log()
        end,
        desc = "Git log",
      },
      {
        "<leader>gL",
        function()
          require("snacks").picker.git_log_line()
        end,
        desc = "Git log line",
      },
      {
        "<leader>gs",
        function()
          require("snacks").picker.git_status()
        end,
        desc = "Git status",
      },
      {
        "<leader>gS",
        function()
          require("snacks").picker.git_stash()
        end,
        desc = "Git stash",
      },
      {
        "<leader>gd",
        function()
          require("snacks").picker.git_diff()
        end,
        desc = "Git diff hunks",
      },
      {
        "<leader>gf",
        function()
          require("snacks").picker.git_log_file()
        end,
        desc = "Git log file",
      },
      {
        "<leader>ss",
        function()
          require("snacks").picker.lsp_symbols()
        end,
        desc = "LSP symbols",
      },
      {
        "<leader>sS",
        function()
          require("snacks").picker.lsp_workspace_symbols()
        end,
        desc = "Workspace symbols",
      },
      {
        "<C-/>",
        function()
          require("snacks").terminal()
        end,
        desc = "Toggle terminal",
      },
      {
        "<leader>.",
        function()
          require("snacks").scratch()
        end,
        desc = "Scratch buffer",
      },
      {
        "<leader>S",
        function()
          require("snacks").scratch.select()
        end,
        desc = "Select scratch buffer",
      },
    },
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = false },
      indent = { enabled = true },
      notifier = { enabled = true },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP locations" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
      { "<leader>tl", "<cmd>Trouble todo toggle<cr>", desc = "Todo list" },
    },
    opts = {},
  },
}
