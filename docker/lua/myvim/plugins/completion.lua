return {
  { "honza/vim-snippets", event = "InsertEnter" },
  { "hrsh7th/vim-vsnip", event = "InsertEnter" },
  { "rafamadriz/friendly-snippets", event = "InsertEnter" },
  { "onsails/lspkind-nvim", event = "InsertEnter" },
  { "hrsh7th/cmp-buffer", event = { "InsertEnter", "CmdlineEnter" } },
  { "hrsh7th/cmp-cmdline", event = "CmdlineEnter" },
  { "uga-rosa/cmp-dictionary", event = "InsertEnter" },
  { "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
  { "hrsh7th/cmp-path", event = { "InsertEnter", "CmdlineEnter" } },
  { "hrsh7th/cmp-vsnip", event = "InsertEnter" },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "uga-rosa/cmp-dictionary",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "onsails/lspkind-nvim",
      "rafamadriz/friendly-snippets",
      "windwp/nvim-autopairs",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        if col == 0 then
          return false
        end
        local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1] or ""
        return text:sub(col, col):match("%s") == nil
      end

      local dictionary_path = vim.fn.stdpath("config") .. "/dict/words.txt"
      if vim.fn.filereadable(dictionary_path) == 1 then
        require("cmp_dictionary").setup({
          dic = {
            ["*"] = { dictionary_path },
          },
        })
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "vsnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
          { name = "dictionary", keyword_length = 2 },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            before = function(entry, vim_item)
              vim_item.menu = string.format("[%s]", entry.source.name:upper())
              return vim_item
            end,
          }),
        },
      })

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      vim.keymap.set("i", "<C-j>", function()
        return vim.fn["vsnip#jumpable"](1) == 1 and "<Plug>(vsnip-jump-next)" or "<C-j>"
      end, { expr = true, desc = "Next snippet jump" })

      vim.keymap.set("i", "<C-k>", function()
        return vim.fn["vsnip#jumpable"](-1) == 1 and "<Plug>(vsnip-jump-prev)" or "<C-k>"
      end, { expr = true, desc = "Previous snippet jump" })
    end,
  },
}
