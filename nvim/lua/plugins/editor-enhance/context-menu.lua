vim.keymap.set({ "v", "n", "t" }, "<M-l>", function() -- use wezterm remapping <c-enter> to "<M-l>"
  require("context-menu.picker.vim-ui").select()
end, {})
vim.keymap.set({ "v", "n", "t" }, "<C-CR>", function() -- same function by keybinding for neovide
  require("context-menu.picker.vim-ui").select()
end, {})

return {
  -- "LintaoAmons/context-menu.nvim",
  dir = "/Volumes/t7ex/Documents/oatnil/vim/context-menu.nvim",
  config = function()
    require("context-menu").setup({
      modules = { "markdown", "git", "http", "copy", "json" },
    })
    require("context-menu").add_items({
      {
        order = 1,
        name = "Code Action",
        not_ft = { "markdown", "toggleterm" },
        action = function(_)
          vim.lsp.buf.code_action()
        end,
      },
    })
  end,
}
