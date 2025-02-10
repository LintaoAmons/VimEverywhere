if true then return {} end -- disable this file

return {
  "b0o/incline.nvim",
  event = "UIEnter",
  config = function()
    local helpers = require("incline.helpers")
    local devicons = require("nvim-web-devicons")
    require("incline").setup({
      highlight = {
        groups = {
          InclineNormal = { guibg = "#44406e" },
          InclineNormalNC = { guifg = "#3D4143", guibg = "#202325" },
        },
      },

      window = {
        padding = 0,
        margin = { horizontal = 0 },
      },
      render = function(props)
        local full_path = require("util.editor").buf.read.get_buf_relative_dir_path(props.buf)
        vim.print(full_path)

        local filename = vim.fn.fnamemodify(full_path, ":t")
        local ft_icon, ft_color = devicons.get_icon_color(filename)

        if full_path == "" then
          filename = "[No Name]"
        else
          -- Use full path only if it's shorter than 30 characters
          filename = #full_path > 30 and vim.fn.pathshorten(full_path) or full_path
        end

        local modified = vim.bo[props.buf].modified
        return {
          -- stylua: ignore start
          ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
          " ",
          { filename, gui = modified and "bold,italic" or "bold" },
          " ",
          -- stylua: ignore end
        }
      end,
    })
  end,
}
