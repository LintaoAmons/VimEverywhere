if true then return {} end -- back to indent-backline

return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = false,
      },
      indent = {
        enable = true,
      },
      line_num = {
        enable = true,
      }
    })
  end,
}
