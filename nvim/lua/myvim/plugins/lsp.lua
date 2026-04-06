return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local function single_file_root(markers)
        return function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          local root = vim.fs.root(bufnr, markers)
          if root then
            on_dir(root)
            return
          end

          if fname ~= "" then
            on_dir(vim.fs.dirname(fname))
            return
          end

          on_dir(vim.uv.cwd())
        end
      end

      local servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=never",
            "--query-driver=/usr/bin/g++,/usr/bin/*g++,/usr/bin/clang++,/usr/bin/*clang++",
            "-j=2",
          },
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
          root_dir = single_file_root({ ".clangd", ".clang-tidy", "compile_commands.json", "compile_flags.txt", ".git" }),
          init_options = {
            fallbackFlags = {
              "-Wall",
              "-Wextra",
              "-pedantic",
              "-Wno-unused-result",
              "-Wconversion",
              "-Wvla",
            },
          },
        },
        pylsp = {
          cmd = { "pylsp" },
          root_dir = single_file_root({ ".git", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt" }),
        },
      }

      for server, config in pairs(servers) do
        if not config.cmd or vim.fn.executable(config.cmd[1]) == 1 then
          config.capabilities = capabilities
          vim.lsp.config(server, config)
          vim.lsp.enable(server)
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("myvim-lsp", { clear = true }),
        callback = function(event)
          local opts = { buffer = event.buf, silent = true }
          vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set({ "n", "v" }, "<leader>qf", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
        end,
      })
    end,
  },
}
