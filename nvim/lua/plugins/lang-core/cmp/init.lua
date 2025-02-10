return {
  { import = "plugins.lang-core.cmp" },
  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        -- formatting from colorful-menu.nvim
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local completion_item = entry:get_completion_item()
            local highlights_info =
              require("colorful-menu").highlights(completion_item, vim.bo.filetype)

            -- error, such as missing parser, fallback to use raw label.
            if highlights_info == nil then
              vim_item.abbr = completion_item.label
            else
              vim_item.abbr_hl_group = highlights_info.highlights
              vim_item.abbr = highlights_info.text
            end

            local kind = require("lspkind").cmp_format({
              mode = "symbol_text",
            })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            vim_item.kind = " " .. (strings[1] or "") .. " "
            vim_item.menu = ""

            return vim_item
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          -- ["<S-CR>"] = cmp.mapping.confirm({
          --   behavior = cmp.ConfirmBehavior.Replace,
          --   select = true,
          -- }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          -- ["<C-CR>"] = function(fallback)
          --   cmp.abort()
          --   fallback()
          -- end,
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        -- experimental = {
        --   ghost_text = {
        --     hl_group = "CmpGhostText",
        --   },
        -- },
        sorting = defaults.sorting,
      }
    end,
    ---@param opts cmp.ConfigSchema
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
      require("cmp").setup(opts)
    end,
  },
}
