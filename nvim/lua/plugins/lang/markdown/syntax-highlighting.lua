return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- ## use opts to extend the ensure_installed table
    vim.g.config_utils.opts_ensure_installed(opts, {
      "markdown",
      "markdown_inline",
    })
  end,
}
