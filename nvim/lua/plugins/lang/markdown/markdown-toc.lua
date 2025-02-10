return {
  "LintaoAmons/markdown-toc.nvim",
  ft = "markdown", -- Lazy load on markdown filetype
  cmd = { "Mtoc" }, -- Or, lazy load on "Mtoc" command
  opts = {
    headings = {
      -- Include headings before the ToC (or current line for `:Mtoc insert`)
      before_toc = false,
      -- Either list of lua patterns,
      -- or a function that returns boolean (true means to EXCLUDE heading)
      exclude = {},
      pattern = "^(#+)%s+(.+)$",
    },
  },
}
