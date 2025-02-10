vim.keymap.set("n", "<leader>wO", function()
  Snacks.zen({
    toggles = {
      dim = false,
      git_signs = true,
      mini_diff_signs = false,
    },
  })
end, { desc = "maxmise_windows" })

return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    ---@class snacks.zen.Config
    zen = {
      -- You can add any `Snacks.toggle` id here.
      -- Toggle state is restored when the window is closed.
      -- Toggle config options are NOT merged.
      ---@type table<string, boolean>
      toggles = {
        dim = true,
        git_signs = false,
        mini_diff_signs = false,
        -- diagnostics = false,
        -- inlay_hints = false,
      },
      show = {
        statusline = false, -- can only be shown when using the global statusline
        tabline = false,
      },
      ---@type snacks.win.Config
      win = { style = "zen", width = 180 },
      --- Callback when the window is opened.
      ---@param win snacks.win
      on_open = function(win) end,
      --- Callback when the window is closed.
      ---@param win snacks.win
      on_close = function(win) end,
      --- Options for the `Snacks.zen.zoom()`
      ---@type snacks.zen.Config
      zoom = {
        toggles = {},
        show = { statusline = true, tabline = true },
        win = {
          backdrop = false,
          width = 0, -- full width
        },
      },
    },
  },
}
