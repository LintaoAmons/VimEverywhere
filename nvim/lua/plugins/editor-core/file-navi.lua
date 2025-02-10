local function reveal_current_file()
  local command = "Neotree reveal reveal_force_cwd"
  vim.keymap.set("n", "<leader>fl", "<cmd>" .. command .. "<cr>", { noremap = true, silent = true })
  vim.api.nvim_create_user_command("LocateCurrentBuf", command, {})
end
reveal_current_file()

vim.keymap.set("n", "<M-1>", "<cmd>Neotree toggle<cr>", { desc = "ExplorerToggle" })
vim.keymap.set("n", "<D-1>", "<cmd>Neotree toggle<cr>", { desc = "ExplorerToggle" })

return {
  { import = "plugins.editor-core.file-navi" },
}
