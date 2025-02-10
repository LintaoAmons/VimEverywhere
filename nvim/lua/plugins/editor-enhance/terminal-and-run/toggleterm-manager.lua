if true then return {} end -- I have my own toggleterm-telescope

return {
  "ryanmsnyder/toggleterm-manager.nvim",
  dependencies = {
    "akinsho/toggleterm.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
  },
  config = true,
}
