return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      if wk.add then
        wk.add({
          { "m", group = "flash", mode = { "n", "x", "o" } },
        })
      end
    end,
    keys = {
      {
        "m/",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash Jump",
      },
      {
        "mt",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "mr",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash Treesitter Search",
      },
      {
        "mw",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            pattern = ".",
            search = {
              mode = function(pattern)
                if pattern:sub(1, 1) == "." then
                  pattern = pattern:sub(2)
                end
                return ([[\<%s\w*\>]]):format(pattern), ([[\<%s]]):format(pattern)
              end,
            },
            jump = { pos = "range" },
          })
        end,
        desc = "Flash Word",
      },
      {
        "ml",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = { mode = "search", max_length = 0 },
            label = { after = { 0, 0 } },
            pattern = "^",
          })
        end,
        desc = "Flash Line",
      },
      {
        "mn",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({ continue = true })
        end,
        desc = "Flash Next",
      },
      {
        "ms",
        mode = { "n", "x", "o" },
        function()
          local flash = require("flash")

          local function format(opts)
            return {
              { opts.match.label1, "FlashMatch" },
              { opts.match.label2, "FlashLabel" },
            }
          end

          flash.jump({
            search = { mode = "search" },
            label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
            pattern = [[\<]],
            action = function(match, state)
              state:hide()
              flash.jump({
                search = { max_length = 0 },
                highlight = { matches = false },
                label = { format = format },
                matcher = function(win)
                  return vim.tbl_filter(function(m)
                    return m.label == match.label and m.win == win
                  end, state.results)
                end,
                labeler = function(matches)
                  for _, m in ipairs(matches) do
                    m.label = m.label2
                  end
                end,
              })
            end,
            labeler = function(matches, state)
              local labels = state:labels()
              for i, match in ipairs(matches) do
                match.label1 = labels[math.floor((i - 1) / #labels) + 1]
                match.label2 = labels[(i - 1) % #labels + 1]
                match.label = match.label1
              end
            end,
          })
        end,
        desc = "Flash Quick",
      },
    },
  },
}
