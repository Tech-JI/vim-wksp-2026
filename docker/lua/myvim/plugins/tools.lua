return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        bash = { "shellcheck" },
        sh = { "shellcheck" },
        c = { "cpplint" },
        cpp = { "cpplint" },
      }

      lint.linters.cpplint.args = {
        "--linelength=120",
        "--filter=-legal,-readability/casting,-whitespace,-runtime/printf,-runtime/threadsafe_fn,-readability/todo,-build/include_subdir,-build/header_guard",
      }

      local function ready_linters(ft)
        local names = lint.linters_by_ft[ft] or {}
        local ready = {}

        for _, name in ipairs(names) do
          local spec = lint.linters[name]
          local cmd = spec and spec.cmd or nil
          if type(cmd) == "table" then
            cmd = cmd[1]
          end
          if type(cmd) == "string" and vim.fn.executable(cmd) == 1 then
            table.insert(ready, name)
          end
        end

        return ready
      end

      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("myvim-lint", { clear = true }),
        callback = function()
          local linters = ready_linters(vim.bo.filetype)
          if #linters > 0 then
            lint.try_lint(linters)
          end
        end,
      })
    end,
  },
  {
    "mhartington/formatter.nvim",
    cmd = { "Format", "FormatWrite" },
    keys = {
      { "<leader>f", "<cmd>FormatWrite<cr>", desc = "Format buffer" },
      { "<leader>cf", "<cmd>FormatWrite<cr>", desc = "Format buffer" },
    },
    config = function()
      local util = require("formatter.util")

      require("formatter").setup({
        logging = false,
        filetype = {
          bash = {
            function()
              if vim.fn.executable("shfmt") ~= 1 then
                return nil
              end
              return { exe = "shfmt", stdin = true }
            end,
          },
          c = {
            function()
              if vim.fn.executable("clang-format") ~= 1 then
                return nil
              end
              return {
                exe = "clang-format",
                stdin = true,
                cwd = vim.fn.expand("%:p:h"),
              }
            end,
          },
          cpp = {
            function()
              if vim.fn.executable("clang-format") ~= 1 then
                return nil
              end
              return {
                exe = "clang-format",
                stdin = true,
                args = { util.escape_path(util.get_current_buffer_file_path()) },
              }
            end,
          },
          json = {
            function()
              if vim.fn.executable("clang-format") ~= 1 then
                return nil
              end
              return { exe = "clang-format", stdin = true }
            end,
          },
          lua = {
            function()
              if vim.fn.executable("stylua") ~= 1 then
                return nil
              end
              return {
                exe = "stylua",
                args = {
                  "--search-parent-directories",
                  "--stdin-filepath",
                  util.escape_path(util.get_current_buffer_file_path()),
                  "--",
                  "-",
                },
                stdin = true,
              }
            end,
          },
        },
      })

      vim.keymap.set("n", "<leader>f", "<cmd>FormatWrite<cr>", { silent = true, desc = "Format buffer" })
      vim.keymap.set("n", "<leader>cf", "<cmd>FormatWrite<cr>", { silent = true, desc = "Format buffer" })
    end,
  },
}
