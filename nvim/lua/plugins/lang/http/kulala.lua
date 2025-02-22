return {
  -- HTTP REST-Client Interface
  {
    "mistweaverco/kulala.nvim",
    -- dir = "/Volumes/t7ex/Documents/oatnil/alpha/kulala.nvim",
    config = function()
      -- -- Setup is required, even if you don't pass any options
      require("kulala").setup({
        default_view = "verbose",
        winbar = true,
      })
    end,
  },
}

