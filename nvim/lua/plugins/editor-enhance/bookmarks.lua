vim.keymap.set("n", "mg", "<cmd>" .. "BookmarksGotoRecent" .. "<cr>")
vim.keymap.set("n", "mm", "<cmd>" .. "BookmarksMark" .. "<cr>")
vim.keymap.set("n", "ma", "<cmd>" .. "BookmarksCommands" .. "<cr>")
vim.keymap.set("n", "ms", "<cmd>" .. "BookmarksInfoCurrentBookmark" .. "<cr>")
vim.keymap.set("n", "mo", "<cmd>" .. "BookmarksGoto" .. "<cr>")

local function hydra_config()
  local Hydra = require("hydra")
  Hydra({
    name = "Bookmarks",
    mode = "n",
    body = "<leader>m",
    hint = [[
      Bookmark Navigation
      
      ^  _j_: Next in List     _J_: Next Bookmark
      ^  _k_: Prev in List     _K_: Prev Bookmark
      ^
      ^ _<Esc>_: Exit
      ]],
    heads = {
      { "j", "<cmd>BookmarksGotoNextInList<cr>" },
      { "k", "<cmd>BookmarksGotoPrevInList<cr>" },
      { "J", "<cmd>BookmarksGotoNext<cr>" },
      { "K", "<cmd>BookmarksGotoPrev<cr>" },
    },
  })
end

return {
  -- "LintaoAmons/bookmarks.nvim",
  -- recommand, pin the plugin at specific version for stability
  -- backup your db.json file when you want to upgrade the plugin
  -- tag = "v2.0.0",
  -- dir = "/Users/oatnil/Documents/oatnil/vim/bookmarks.nvim",
  dir = "/Volumes/t7ex/Documents/oatnil/release/bookmarks.nvim",
  dependencies = {
    { "kkharji/sqlite.lua" },
    { "nvim-telescope/telescope.nvim" },
    { "stevearc/dressing.nvim" }, -- optional: better UI
  },
  config = function()
    hydra_config()

    local opts = {
      -- Directory to store the database file
      -- Default: vim.fn.stdpath("data")
      -- You can set a custom directory
      -- The plugin will:
      --   1. Create the directory if it doesn't exist
      --   2. Create `bookmarks.sqlite.db` inside this directory
      ---@type string?
      db_dir = nil, -- if nil, fallback to default `stdpath("data")`

      -- Bookmarks sign configurations
      signs = {
        -- Sign mark icon and color in the gutter
        mark = {
          icon = "󰃁",
          color = "red",
          line_bg = "#572626",
        },
      },

      codecompanion = {
        enabled = true,
      },

      picker = {
        -- telescope entry display generation logic
        ---@type: fun(bookmark: Bookmarks.Node): string
        entry_display = nil,
      },

      -- Bookmark position calibration
      calibrate = {
        -- Auto adjust window position when opening buffer
        auto_calibrate_cur_buf = false,
      },

      -- Custom commands available in command picker
      ---@type table<string, function>
      commands = {
        -- Example: Add warning bookmark
        mark_warning = function()
          vim.ui.input({ prompt = "[Warn Bookmark]" }, function(input)
            if input then
              local Service = require("bookmarks.domain.service")
              Service.toggle_mark("⚠ " .. input)
              require("bookmarks.sign").safe_refresh_signs()
            end
          end)
        end,
        -- Example: Create list for current project
        create_project_list = function()
          local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          local Service = require("bookmarks.domain.service")
          local new_list = Service.create_list(project_name)
          Service.set_active_list(new_list.id)
          require("bookmarks.sign").safe_refresh_signs()
        end,
      },

      treeview = {
        highlights = {
          active_list = {
            bg = "#A13C3C", -- Background color
            fg = "#ffffff", -- Text color
            bold = true, -- Make text bold
          },
        },
        active_list_icon = "👀 ",
        ---@type { keymap: { [string]: string|string[] } } 
        -- stylua: ignore start
        keymap = {
          quit = { "q", "<ESC>" },      -- Close the tree view window and return to previous window
          refresh = "R",                -- Reload and redraw the tree view
          create_list = "a",            -- Create a new list under the current node
          level_up = "u",               -- Navigate up one level in the tree hierarchy
          set_root = ".",               -- Set current list as root of the tree view, also set as active list
          set_active = "m",             -- Set current list as the active list for bookmarks
          toggle = "o",                 -- Toggle list expansion or go to bookmark location
          move_up = "<localleader>k",   -- Move current node up in the list
          move_down = "<localleader>j", -- Move current node down in the list
          delete = "D",                 -- Delete current node
          rename = "r",                 -- Rename current node
          goto = "g",                   -- Go to bookmark location in previous window
          cut = "x",
          copy = "c",
          paste = "p",
        },
        -- stylua: ignore end
      },
    }
    require("bookmarks").setup(opts)
  end,
}
