local group_name = "langHttp"
vim.api.nvim_create_augroup(group_name, { clear = true })

-- Set indentation to 2 spaces
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group_name,
  pattern = {
    "*.http",
  },
  command = "setlocal ft=http",
})

return {
  -- HTTP REST-Client Interface
  {
    "mistweaverco/kulala.nvim",
    -- dir = "/Volumes/t7ex/Documents/oatnil/alpha/kulala.nvim",
    config = function()
      -- -- Setup is required, even if you don't pass any options
      require("kulala").setup({
        default_view = "headers_body",
      })
    end,
  },
}
