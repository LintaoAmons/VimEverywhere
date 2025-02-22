local fts = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "less",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
}

return {
  -- # Format
  {
    "stevearc/conform.nvim",
    -- use opts to extend the formatters_by_ft table
    opts = function(_, opts)
      for _, ft in ipairs(fts) do
        opts.formatters_by_ft[ft] = { "prettier" }
      end
    end,
  },
}
