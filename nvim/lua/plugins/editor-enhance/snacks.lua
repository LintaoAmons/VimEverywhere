return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
      top_down = false, -- place notifications from top to bottom
    },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
      lazygit = {
        width = 0,
        height = 0,
      },
    },
  },
}
