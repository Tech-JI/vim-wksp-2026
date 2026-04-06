local bootstrap = vim.env.MYVIM_BOOTSTRAP == "1"

return {
  {
    "folke/tokyonight.nvim",
    lazy = bootstrap,
    priority = 1000,
    opts = {
      style = "moon",
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "transparent",
        floats = "transparent",
      },
      sidebars = { "qf", "help" },
      lualine_bold = true,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({})
      if wk.add then
        wk.add({
          { "<leader>b", group = "buffers" },
          { "<leader>c", group = "code" },
          { "<leader>g", group = "git" },
          { "<leader>h", group = "history" },
          { "<leader>l", group = "lsp" },
          { "<leader>s", group = "search" },
          { "<leader>t", group = "toggle" },
          { "<leader>x", group = "diagnostics" },
        })
      end
    end,
  },
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },
}
