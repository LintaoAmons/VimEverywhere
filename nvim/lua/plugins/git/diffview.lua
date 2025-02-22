return {
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local action = require("diffview.actions")
      require("diffview").setup({
        keymaps = {
          view = {
            ["r"] = function()
              vim.cmd("GitResetHunk")
              vim.notify("Reset hunk")
              vim.cmd("DiffviewRefresh")
            end,
            ["gf"] = function()
              local diffview_tab = vim.api.nvim_get_current_tabpage()
              action.goto_file_edit()
              vim.api.nvim_command("tabclose " .. diffview_tab)
            end,
          },
          file_history_panel = {
            { "n", "fa", "g!=a", { remap = true } },
            { "n", "ff", "g!--", { remap = true } },
          },
          file_panel = {
          },
        },
        view = {
          default = {
            winbar_info = true,
          },
          file_history = {
            winbar_info = true,
          },
        },
      })
    end,
  },
}
