if true then return {} end -- disable this file

return {

  -- # LSP
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      -- ## ensure_install lang specfic LSP
      vim.g.config_utils.opts_ensure_installed(opts, { "ltex" })

      -- ## extend the servers table
      opts.servers = opts.servers or {}
      opts.servers.lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
          ltex = {
            language = "en-GB",
          },
        },
      }
    end,
  },
}
