local group_name = "langJsTs"
vim.api.nvim_create_augroup(group_name, { clear = true })

-- use as example to show how to automatically set the indentation of a specific filetype
-- Set indentation to 2 spaces
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group_name,
  pattern = {
    "*.js",
    "*.ts",
  },
  command = "setlocal shiftwidth=2 tabstop=2",
})

return { { import = "plugins.lang.jsts" } }

-- REFs:
-- - https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/typescript.lua
-- - https://github.com/AstroNvim/astrocommunity/blob/f219659b67b246584c421074d73db0a941af5cbd/lua/astrocommunity/pack/typescript/init.lua
-- - https://github.com/anasrar/.dotfiles/blob/4c444c3ab2986db6ca7e2a47068222e47fd232e2/neovim/.config/nvim/lua/rin/DAP/languages/typescript.lua
