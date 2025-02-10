return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.g.config_utils.opts_ensure_installed(opts, {
      "javascript",
      "typescript",
      "tsx",
      "jsdoc",
      "prisma",
    })
  end,
}
