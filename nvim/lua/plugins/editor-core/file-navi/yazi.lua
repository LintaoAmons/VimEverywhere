vim.keymap.set("n", "<leader>ee", "<cmd>Yazi<cr>", { noremap = true, silent = true })

return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = "g?",
    },
  },
}
