vim.api.nvim_create_user_command("PutMessage", function()
  vim.cmd([[put =execute('messages')]])
end, {})

return {
  { import = "plugins.editor-enhance.dev" },
}
