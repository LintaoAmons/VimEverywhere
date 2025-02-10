return {
  "MaximilianLloyd/tw-values.nvim",
  keys = {
    { "<Leader>cv", "<CMD>TWValues<CR>", desc = "Tailwind CSS values" },
  },
  opts = {
    border = "rounded", -- Valid window border style,
    show_unknown_classes = true, -- Shows the unknown classes popup
    focus_preview = true,
  },
}
