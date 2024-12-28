return {
    "LintaoAmons/context-menu.nvim",
    opts = function()
      require("context-menu").setup({
        menu_items = {
          {
            cmd = "Run File",
            order = 1,
            not_ft = { "markdown", "toggleterm" },
            action = {
              type = "callback",
              callback = function(context)
                if context.ft == "lua" then
                  return vim.cmd([[source %]])
                elseif context.ft == "javascript" then
                  local stdout = vim.fn.system("node " .. vim.fn.expand("%:p"))
                  local result = require("util.base.strings").split_into_lines(stdout)
                  require("util.editor").split_and_write(result, {})
                elseif context.ft == "typescript" then
                  local stdout = vim.fn.system("deno " .. vim.fn.expand("%:p"))
                  local result = require("util.base.strings").split_into_lines(stdout)
                  require("util.editor").split_and_write(result, {})
                end
              end,
            },
          },
          {
            cmd = "Close Terminal",
            order = 1,
            ft = { "toggleterm" },
            action = {
              type = "callback",
              callback = function(context)
                vim.cmd("bd!")
              end,
            },
          },
          {
            cmd = "Terminal",
            keymap = "t",
            action = {
              type = "sub_cmds",
              sub_cmds = {
                {
                  cmd = "Select Terminal",
                  action = {
                    type = "callback",
                    callback = function(_)
                      vim.cmd("TermSelect")
                    end,
                  },
                },
                {
                  cmd = "New Terminal :: Tab",
                  action = {
                    type = "callback",
                    callback = function(_)
                      require("toggleterm.terminal").Terminal
                        :new({
                          display_name = "Tab",
                          direction = "tab",
                          dir = vim.fn.expand("%:p:h"),
                          auto_scroll = true, -- automatically scroll to the bottom on terminal output
                        })
                        :toggle()
                    end,
                  },
                },
                {
                  cmd = "Close Terminal",
                  action = {
                    type = "callback",
                    callback = function(_)
                      vim.cmd("bd!")
                    end,
                  },
                },
              },
            },
          },
          -- {
          --   cmd = "Popup Terminal",
          --   order = 1,
          --   not_ft = { "markdown" },
          --   action = {
          --     type = "callback",
          --     callback = function(_)
          --       popup_terminal()
          --     end,
          --   },
          -- },
        },
      })
    end,
  }
