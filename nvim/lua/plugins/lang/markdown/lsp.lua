return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.g.config_utils.opts_ensure_installed(opts, { "marksman" })
    end,
  }, -- ## ensure_install lang specfic LSP
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      -- ## use opts to extend the ensure_installed table
      vim.g.config_utils.opts_ensure_installed(opts, { "marksman" })
    end,
  },
}
