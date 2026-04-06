return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = { "Telescope" },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find files",
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Find buffers",
      },
      {
        "<leader>fl",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Live grep",
      },
      {
        "<leader>fk",
        function()
          require("telescope.builtin").keymaps()
        end,
        desc = "Find keymaps",
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Help tags",
      },
      {
        "<leader>fw",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find()
        end,
        desc = "Current buffer search",
      },
      {
        "<leader>fo",
        function()
          require("telescope.builtin").oldfiles()
        end,
        desc = "Old files",
      },
      {
        "<leader>fa",
        function()
          require("telescope.builtin").builtin()
        end,
        desc = "Telescope builtins",
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({})

      pcall(telescope.load_extension, "zoxide")
    end,
  },
  {
    "jvgrootveld/telescope-zoxide",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local telescope = require("telescope")
      local z_utils = require("telescope._extensions.zoxide.utils")

      telescope.setup({
        extensions = {
          zoxide = {
            prompt_title = "[ Walking on the shoulders of TJ ]",
            mappings = {
              default = {
                after_action = function(selection)
                  print(string.format("Update to (%s) %s", selection.z_score, selection.path))
                end,
              },
              ["<C-s>"] = {
                before_action = function()
                end,
                action = function(selection)
                  vim.cmd.edit(selection.path)
                end,
              },
              ["<C-q>"] = {
                action = z_utils.create_basic_command("split"),
              },
            },
          },
        },
      })

      pcall(telescope.load_extension, "zoxide")
    end,
    keys = {
      { "<leader>cd", "<cmd>Telescope zoxide list<cr>", desc = "Zoxide" },
    },
  },
}
