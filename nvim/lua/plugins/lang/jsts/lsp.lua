return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    {
      -- NOTE: use vtsls instead of typescript-language-server
      "yioneko/nvim-vtsls",
      lazy = true,
      opts = {},
      config = function()
        require("vtsls").config({})
      end,
    },
  },
  opts = function(_, opts)
    -- ## ensure install lang specfic LSP
    vim.g.config_utils.opts_ensure_installed(opts, { "lua_ls" })

    -- ## extend the servers table
    opts.servers = opts.servers or {}

    opts.servers.tsserver = {
      enabled = false,
    }
    opts.servers.vtsls = {
      -- explicitly add default filetypes, so that we can extend
      -- them in related extras
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      settings = {
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
        },
        typescript = {
          updateImportsOnFileMove = { enabled = "always" },
          suggest = {
            completeFunctionCalls = true,
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
    }
  end,
}
