return {
  {
    "stevearc/overseer.nvim",
    opts = {},
  },
  {
    "LintaoAmons/context-menu.nvim",
    config = function()
      require("context-menu").setup({
        close_menu = { "q", "<ESC>", "<M-l>" },
        menu_items = {
          {
            cmd = "Tasks",
            keymap = "a",
            action = {
              type = "sub_cmds",
              sub_cmds = {
                {
                  cmd = "Toggle",
                  keymap = "a",
                  action = {
                    type = "callback",
                    callback = function(_)
                      vim.cmd([[OverseerToggle]])
                    end,
                  },
                },
                {
                  cmd = "Run",
                  keymap = "r",
                  action = {
                    type = "callback",
                    callback = function(_)
                      vim.cmd([[OverseerRun]])
                    end,
                  },
                },
              },
            },
          },
        },
      })
    end,
  },
}
