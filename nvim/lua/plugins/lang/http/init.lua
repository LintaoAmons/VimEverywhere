local group_name = "langHttp"
vim.api.nvim_create_augroup(group_name, { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group_name,
  pattern = {
    "*.http",
  },
  command = "setlocal ft=http",
})

return { { import = "plugins.lang.http" } }
