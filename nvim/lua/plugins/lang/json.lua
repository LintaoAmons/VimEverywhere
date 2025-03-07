local jq_query = function()
  local sys = require("util.base.sys")
  local editor = require("util.editor")

  vim.ui.input({ prompt = 'Query pattern, e.g. `.[] | .["@message"].message` ' }, function(pattern)
    local absPath = editor.buf.read.get_buf_abs_path()
    local stdout, _, stderr = sys.run_sync({ "jq", pattern, absPath }, ".")
    local result = stdout or stderr
    editor.split_and_write(result, { vertical = true, ft = "json" })
  end)
end

return {
  -- # Syntax hightlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- ## use opts to extend the ensure_installed table
      vim.g.config_utils.opts_ensure_installed(opts, { "json", "jsonc" })
    end,
  },

  -- # Format
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        json = { "jq", "prettierd", stop_after_first = true },
        json5 = { "prettierd" },
        jsonc = { "prettierd" },
      },
    },
  },
}
