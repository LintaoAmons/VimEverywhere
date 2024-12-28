vim.cmd([[cab k Kubectl]])
vim.keymap.set("n", "<leader>k", '<cmd>lua require("kubectl").toggle()<cr>', { noremap = true, silent = true })

return {
  {
    "ramilito/kubectl.nvim",
    config = function()
      require("kubectl").setup()
    end,
  },
}
