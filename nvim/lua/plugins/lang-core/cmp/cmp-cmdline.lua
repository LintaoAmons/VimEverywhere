return {
    "hrsh7th/cmp-cmdline",
    keys = { ":", "/", "?" }, -- lazy load cmp on more keys along with insert mode
    dependencies = { "hrsh7th/nvim-cmp" },
    opts = function()
      local cmp = require("cmp")
      return {
        {
          type = "/",
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = "buffer" },
          },
        },
        {
          type = ":",
          mapping = cmp.mapping.preset.cmdline({

            ["<Down>"] = {
              c = function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                else
                  fallback()
                end
              end,
            },
            ["<Up>"] = {
              c = function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                else
                  fallback()
                end
              end,
            },
            ["<Tab>"] = {
              c = function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                  cmp.select_prev_item()
                else
                  fallback()
                end
              end,
            },
          }),
          sources = cmp.config.sources({
            { name = "path" },
          }, {
            {
              name = "cmdline",
              option = {
                ignore_cmds = { "Man", "!" },
              },
            },
          }),
        },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      vim.tbl_map(function(val)
        cmp.setup.cmdline(val.type, val)
      end, opts)
    end,
  }
