local formatFunc = function(args)
  local range = nil
  if args and args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_fallback = true, range = range })
end
vim.keymap.set("n", "<leader>fm", formatFunc)
vim.api.nvim_create_user_command("Format", formatFunc, { range = true })

return {
  "stevearc/conform.nvim",

  config = function(_, opts)
    require("conform").setup(opts)
  end,
}
