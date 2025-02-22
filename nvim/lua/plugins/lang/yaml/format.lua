return {
  -- # Format
  {
    "stevearc/conform.nvim",
    -- use opts to extend the formatters_by_ft table
    opts = function(_, opts)
      opts.formatters_by_ft['yaml'] = { "prettierd" }
    end,
  },
}
