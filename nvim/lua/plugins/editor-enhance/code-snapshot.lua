return {
  enabled = false,
  "mistricky/codesnap.nvim",
  build = "make",
  config = function()
    require("codesnap").setup({
      bg_x_padding = 50,
      bg_y_padding = 32,
      watermark = "程序dd",
    })
  end,
}
