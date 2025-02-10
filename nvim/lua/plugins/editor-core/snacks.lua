vim.keymap.set({ "n", "v", "i" }, "<C-M-P>", function()
  Snacks.picker.commands()
end, { noremap = false, silent = true })

vim.api.nvim_create_user_command("Notifications", function()
  Snacks.notifier.show_history()
end, { desc = "should snacks notifications" })

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,

  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    notifier = {
      timeout = 3000, -- default timeout in ms
      width = { min = 40, max = 0.4 },
      height = { min = 1, max = 0.6 },
      -- editor margin to keep free. tabline and statusline are taken into account automatically
      margin = { top = 0, right = 1, bottom = 0 },
      padding = true, -- add 1 cell of left/right padding to the notification window
      sort = { "level", "added" }, -- sort by level and time
      -- minimum log level to display. TRACE is the lowest
      -- all notifications are stored in history
      level = vim.log.levels.TRACE,
      icons = {
        error = " ",
        warn = " ",
        info = " ",
        debug = " ",
        trace = " ",
      },
      keep = function(notif)
        return vim.fn.getcmdpos() > 0
      end,
      ---@type snacks.notifier.style
      style = "compact",
      top_down = false, -- place notifications from top to bottom
      date_format = "%R", -- time format for notifications
      -- format for footer when more lines are available
      -- `%d` is replaced with the number of lines.
      -- only works for styles with a border
      ---@type string|boolean
      more_format = " ↓ %d lines ",
      refresh = 50, -- refresh at most every 50ms
    },
    picker = {
      prompt = " ",
      sources = {
        explorer = {
          hidden = true,
          finder = "explorer",
          sort = { fields = { "sort" } },
          tree = true,
          supports_live = true,
          follow_file = true,
          focus = "list",
          auto_close = false,
          jump = { close = false },
          layout = { preset = "sidebar", preview = false },
          formatters = { file = { filename_only = true } },
          matcher = { sort_empty = true },
          config = function(opts)
            return require("snacks.picker.source.explorer").setup(opts)
          end,
          win = {
            list = {
              keys = {
                ["<BS>"] = "explorer_up",
                ["a"] = "explorer_add",
                ["D"] = "explorer_del",
                ["r"] = "explorer_rename",
                ["c"] = "explorer_copy",
                ["m"] = "explorer_move",
                ["y"] = "explorer_yank",
                ["<c-c>"] = "explorer_cd",
                ["."] = "explorer_focus",
              },
            },
          },
        },
      },
      layout = {
        cycle = true,
        --- Use the default layout or vertical if the window is too narrow
        preset = function()
          return vim.o.columns >= 120 and "default" or "vertical"
        end,
      },
      ui_select = true, -- replace `vim.ui.select` with the snacks picker
      ---@class snacks.picker.formatters.Config
      formatters = {
        file = {
          filename_first = false, -- display filename before the file path
        },
      },
      ---@class snacks.picker.previewers.Config
      previewers = {
        git = {
          native = false, -- use native (terminal) or Neovim for previewing git diffs and commits
        },
        file = {
          max_size = 1024 * 1024, -- 1MB
          max_line_length = 500, -- max line length
          ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
        },
        man_pager = nil, ---@type string? MANPAGER env to use for `man` preview
      },
      win = {
        -- input window
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<C-c>"] = { "close", mode = "i" },
            ["<M-w>"] = { "close", mode = { "n", "i" } },
            -- to close the picker on ESC instead of going to normal mode,
            -- add the following keymap to your config
            -- ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<CR>"] = { "confirm", mode = { "n", "i" } },
            ["G"] = "list_bottom",
            ["gg"] = "list_top",
            ["j"] = "list_down",
            ["k"] = "list_up",
            ["/"] = "toggle_focus",
            ["q"] = "close",
            ["?"] = "toggle_help",
            ["<a-d>"] = { "inspect", mode = { "n", "i" } },
            ["<c-a>"] = { "select_all", mode = { "n", "i" } },
            ["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
            ["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
            ["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
            ["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
            ["<C-Up>"] = { "history_back", mode = { "i", "n" } },
            ["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
            ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
            ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
            ["<Down>"] = { "list_down", mode = { "i", "n" } },
            ["<Up>"] = { "list_up", mode = { "i", "n" } },
            ["<c-j>"] = { "list_down", mode = { "i", "n" } },
            ["<c-k>"] = { "list_up", mode = { "i", "n" } },
            ["<c-n>"] = { "list_down", mode = { "i", "n" } },
            ["<c-p>"] = { "list_up", mode = { "i", "n" } },
            ["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
            ["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<c-g>"] = { "toggle_live", mode = { "i", "n" } },
            ["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
            ["<ScrollWheelDown>"] = { "list_scroll_wheel_down", mode = { "i", "n" } },
            ["<ScrollWheelUp>"] = { "list_scroll_wheel_up", mode = { "i", "n" } },
            ["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
            ["<c-s>"] = { "edit_split", mode = { "i", "n" } },
            ["<c-q>"] = { "qflist", mode = { "i", "n" } },
            ["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
            ["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
          },
          b = {
            minipairs_disable = true,
          },
        },
        -- result list window
        list = {
          keys = {
            ["<CR>"] = "confirm",
            ["gg"] = "list_top",
            ["G"] = "list_bottom",
            ["i"] = "focus_input",
            ["j"] = "list_down",
            ["k"] = "list_up",
            ["q"] = "close",
            ["<Tab>"] = "select_and_next",
            ["<S-Tab>"] = "select_and_prev",
            ["<Down>"] = "list_down",
            ["<Up>"] = "list_up",
            ["<a-d>"] = "inspect",
            ["<c-d>"] = "list_scroll_down",
            ["<c-u>"] = "list_scroll_up",
            ["zt"] = "list_scroll_top",
            ["zb"] = "list_scroll_bottom",
            ["zz"] = "list_scroll_center",
            ["/"] = "toggle_focus",
            ["<ScrollWheelDown>"] = "list_scroll_wheel_down",
            ["<ScrollWheelUp>"] = "list_scroll_wheel_up",
            ["<c-a>"] = "select_all",
            ["<c-f>"] = "preview_scroll_down",
            ["<c-b>"] = "preview_scroll_up",
            ["<c-v>"] = "edit_vsplit",
            ["<c-s>"] = "edit_split",
            ["<c-j>"] = "list_down",
            ["<c-k>"] = "list_up",
            ["<c-n>"] = "list_down",
            ["<c-p>"] = "list_up",
            ["<a-w>"] = "cycle_win",
            ["<Esc>"] = "close",
          },
        },
        -- preview window
        preview = {
          keys = {
            ["<Esc>"] = "close",
            ["q"] = "close",
            ["i"] = "focus_input",
            ["<ScrollWheelDown>"] = "list_scroll_wheel_down",
            ["<ScrollWheelUp>"] = "list_scroll_wheel_up",
            ["<a-w>"] = "cycle_win",
          },
        },
      },
      ---@class snacks.picker.icons
      icons = {
        files = {
          enabled = true, -- show file icons
        },
        indent = {
          vertical = "│ ",
          middle = "├╴",
          last = "└╴",
        },
        ui = {
          live = "󰐰 ",
          selected = "● ",
          -- selected = " ",
        },
        git = {
          commit = "󰜘 ",
        },
        diagnostics = {
          Error = " ",
          Warn = " ",
          Hint = " ",
          Info = " ",
        },
        kinds = {
          Array = " ",
          Boolean = "󰨙 ",
          Class = " ",
          Color = " ",
          Control = " ",
          Collapsed = " ",
          Constant = "󰏿 ",
          Constructor = " ",
          Copilot = " ",
          Enum = " ",
          EnumMember = " ",
          Event = " ",
          Field = " ",
          File = " ",
          Folder = " ",
          Function = "󰊕 ",
          Interface = " ",
          Key = " ",
          Keyword = " ",
          Method = "󰊕 ",
          Module = " ",
          Namespace = "󰦮 ",
          Null = " ",
          Number = "󰎠 ",
          Object = " ",
          Operator = " ",
          Package = " ",
          Property = " ",
          Reference = " ",
          Snippet = "󱄽 ",
          String = " ",
          Struct = "󰆼 ",
          Text = " ",
          TypeParameter = " ",
          Unit = " ",
          Uknown = " ",
          Value = " ",
          Variable = "󰀫 ",
        },
      },
      ---@class snacks.picker.debug
      debug = {
        scores = false, -- show scores in the list
      },
    },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
      notification_history = {
        -- border = "rounded",
        -- zindex = 100,
        width = 0.6,
        position = "right",
        -- height = 0.6,
        minimal = false,
        title = " Notification History ",
        title_pos = "center",
        ft = "markdown",
        bo = { filetype = "snacks_notif_history", modifiable = false },
        wo = { winhighlight = "Normal:SnacksNotifierHistory" },
        keys = { q = "close" },
      },
      lazygit = {
        width = 0,
        height = 0,
      },
    },
  },
}
