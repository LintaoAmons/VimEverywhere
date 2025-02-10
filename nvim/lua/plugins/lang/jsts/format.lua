return {
  -- # Format
  {
    "stevearc/conform.nvim",
    -- use opts to extend the formatters_by_ft table
    opts = function(_, opts)
      opts.formatters_by_ft["javascript"] = { "prettier" }
      opts.formatters_by_ft["typescript"] = { "prettier" }
      opts.formatters_by_ft["tsx"] = { "prettier" }
      opts.formatters_by_ft["jsx"] = { "prettier" }
      opts.formatters_by_ft["jsdoc"] = { "prettier" }
    end,
  },
}
