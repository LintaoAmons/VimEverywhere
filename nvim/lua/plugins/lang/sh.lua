return {
  -- # Format
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft["sh"] = { "shfmt" }
      opts.formatters_by_ft["zsh"] = { "shfmt" }
    end,
  },
}
