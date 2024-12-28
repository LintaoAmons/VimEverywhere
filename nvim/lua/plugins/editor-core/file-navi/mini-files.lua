local function open_mini_files()
  local cmd = function()
    require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
  end

  vim.api.nvim_create_user_command("MiniFiles", cmd, {})
end
open_mini_files()

-- I stil need this plugin to bulk create/rename files
return {
  -- https://github.com/linkarzu/dotfiles-latest/blob/64707e247c71a2536327e33effab57641c54d001/neovim/neobean/lua/plugins/mini-files.lua#L62
  "echasnovski/mini.files",
  version = false,
  config = function()
    require("mini.files").setup({ -- General options
      mappings = {
        close = "q",
        -- Use this if you want to open several files
        go_in = "L",
        -- This opens the file, but quits out of mini.files (default L)
        go_in_plus = "<Right>",
        -- I swapped the following 2 (default go_out: h)
        -- go_out_plus: when you go out, it shows you only 1 item to the right
        -- go_out: shows you all the items to the right
        go_out = "H",
        go_out_plus = "<Left>",
        -- Default <BS>
        reset = ",",
        -- Default @
        reveal_cwd = ".",
        show_help = "g?",
        -- Default =
        synchronize = "s",
        trim_left = "<",
        trim_right = ">",
      },
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 80,
      },
      options = {
        -- Whether to delete permanently or move into module-specific trash
        permanent_delete = false,
        -- Whether to use for editing directories
        use_as_default_explorer = true,
      },
    })

    vim.api.nvim_set_hl(0, "MiniFilesNormal", { bg = "#111111" })
    vim.api.nvim_set_hl(0, "MiniFilesBorder", { bg = "#111111" })
  end,
}
