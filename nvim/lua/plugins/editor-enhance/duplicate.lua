vim.keymap.set("v", "<C-M-j>", "<CMD>VisualDuplicate +1<CR>", { desc = "Duplication" })
vim.keymap.set("v", "<C-M-k>", "<CMD>VisualDuplicate -1<CR>", { desc = "Duplication" })
vim.keymap.set("v", "<C-D-j>", "<CMD>VisualDuplicate +1<CR>", { desc = "Duplication" })
vim.keymap.set("v", "<C-D-k>", "<CMD>VisualDuplicate -1<CR>", { desc = "Duplication" })

return {
  "hinell/duplicate.nvim",
  event = "VeryLazy",
}
