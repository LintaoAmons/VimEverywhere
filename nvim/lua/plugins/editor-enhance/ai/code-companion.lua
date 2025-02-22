local opts = { noremap = true, silent = true }
vim.keymap.set({ "n", "v" }, "<Leader>aj", function()
  vim.cmd("CodeCompanionChat Add")
  -- Find and focus the CodeCompanion buffer window
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "codecompanion" then
      vim.api.nvim_set_current_win(win)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
      break
    end
  end
end, opts)
vim.keymap.set({ "n", "v" }, "<Leader>ak", "<cmd>CodeCompanionActions<cr>", opts)

-- add 2 commands:
--    CodeCompanionSave [space delimited args]
--    CodeCompanionLoad
-- Save will save current chat in a md file named 'space-delimited-args.md'
-- Load will use a telescope filepicker to open a previously saved chat

-- create a folder to store our chats
local Path = require("plenary.path")
local data_path = vim.fn.stdpath("data")
local save_folder = Path:new(data_path, "cc_saves")
if not save_folder:exists() then
  save_folder:mkdir({ parents = true })
end

-- telescope picker for our saved chats
vim.api.nvim_create_user_command("CodeCompanionLoad", function()
  local t_builtin = require("telescope.builtin")
  local t_actions = require("telescope.actions")
  local t_action_state = require("telescope.actions.state")

  local function start_picker()
    t_builtin.find_files({
      prompt_title = "Saved CodeCompanion Chats | <c-d>: delete",
      cwd = save_folder:absolute(),
      attach_mappings = function(_, map)
        map("i", "<c-d>", function(prompt_bufnr)
          local selection = t_action_state.get_selected_entry()
          local filepath = selection.path or selection.filename
          os.remove(filepath)
          t_actions.close(prompt_bufnr)
          start_picker()
        end)
        return true
      end,
    })
  end
  start_picker()
end, {})

-- save current chat, `CodeCompanionSave foo bar baz` will save as 'foo-bar-baz.md'
vim.api.nvim_create_user_command("CodeCompanionSave", function(opts)
  local codecompanion = require("codecompanion")
  local success, chat = pcall(function()
    return codecompanion.buf_get_chat(0)
  end)
  if not success or chat == nil then
    vim.notify(
      "CodeCompanionSave should only be called from CodeCompanion chat buffers",
      vim.log.levels.ERROR
    )
    return
  end
  if #opts.fargs == 0 then
    vim.notify(
      "CodeCompanionSave requires at least 1 arg to make a file name",
      vim.log.levels.ERROR
    )
  end
  local save_name = table.concat(opts.fargs, "-") .. ".md"
  local save_path = Path:new(save_folder, save_name)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  save_path:write(table.concat(lines, "\n"), "w")
end, { nargs = "*" })

return {
  "olimorris/codecompanion.nvim",
  -- dir ="/Volumes/t7ex/Documents/Github/codecompanion.nvim",
  -- dir = "/Volumes/t7ex/Documents/oatnil/vim/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
    "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves the default Neovim UI
  },
  config = function()
    local opts = {
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            url = "https://" .. os.getenv("ANTHROPIC_DOMAIN") .. "/v1/messages",
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "anthropic",
          slash_commands = {
            ["buffer"] = {
              callback = "strategies.chat.slash_commands.buffer",
              description = "Insert open buffers",
              opts = {
                contains_code = true,
                provider = "telescope", -- telescope|mini_pick|fzf_lua
              },
            },
            ["fetch"] = {
              callback = "strategies.chat.slash_commands.fetch",
              description = "Insert URL contents",
              opts = {
                adapter = "jina",
              },
            },
            ["file"] = {
              callback = "strategies.chat.slash_commands.file",
              description = "Insert a file",
              opts = {
                contains_code = true,
                max_lines = 1000,
                provider = "telescope", -- default|telescope|mini_pick|fzf_lua
              },
            },
            ["help"] = {
              callback = "strategies.chat.slash_commands.help",
              description = "Insert content from help tags",
              opts = {
                contains_code = false,
                provider = "telescope", -- telescope|mini_pick|fzf_lua
              },
            },
            ["now"] = {
              callback = "strategies.chat.slash_commands.now",
              description = "Insert the current date and time",
              opts = {
                contains_code = false,
              },
            },
            ["symbols"] = {
              callback = "strategies.chat.slash_commands.symbols",
              description = "Insert symbols for a selected file",
              opts = {
                contains_code = true,
                provider = "default", -- default|telescope|mini_pick|fzf_lua
              },
            },
            ["terminal"] = {
              callback = "strategies.chat.slash_commands.terminal",
              description = "Insert terminal output",
              opts = {
                contains_code = false,
              },
            },
          },
        },
        inline = {
          adapter = "anthropic",
        },
        agent = {
          adapter = "anthropic",
        },
      },
      prompt_library = {
        ["Stage and generate commit msg"] = {
          strategy = "chat",
          description = "staged file commit messages",
          opts = {
            index = 9,
            default_prompt = true,
            mapping = "<LocalLeader>gm",
            slash_cmd = "commit-stage",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = "You are an expert at following the Conventional Commit specification.",
            },
            {
              role = "user",
              contains_code = true,
              content = function()
                vim.fn.system("git add .")
                return "Given the git diff listed below, please generate a commit message and put it inside a commit command for me:\n\n"
                  .. "```\n"
                  .. vim.fn.system("git diff --staged")
                  .. "\n```"
              end,
            },
          },
        },
        ["Commit Message for Staged Files"] = {
          strategy = "chat",
          description = "staged file commit messages",
          opts = {
            index = 9,
            default_prompt = true,
            mapping = "<LocalLeader>gm",
            slash_cmd = "commit-stage",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = "You are an expert at following the Conventional Commit specification.",
            },
            {
              role = "user",
              contains_code = true,
              content = function()
                return "Given the git diff listed below, please generate a commit message and put it inside a commit command for me:\n\n"
                  .. "```\n"
                  .. vim.fn.system("git diff --staged")
                  .. "\n```"
              end,
            },
          },
        },
        ["aws saa"] = {
          strategy = "chat",
          description = "aws saa helper",
          opts = {
            index = 9,
            default_prompt = true,
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = [[You are an expert at AWS Cloud Service and helping me to pass the AWS SAA exam. ]],
            },
            {
              role = "user",
              contains_code = true,
              content = function()
                return " #buffer\n 解答这个题目，并扩展解释其中提到的各种AWS 概念"
              end,
            },
          },
        },

        ["Config Change Commit"] = {
          strategy = "chat",
          description = "my config changed commit",
          opts = {
            index = 9,
            default_prompt = true,
            -- mapping = "<LocalLeader>gm",
            -- slash_cmd = "config-commit-stage",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = [[You are an expert at following the Conventional Commit specification. 
My neovim config changed, you need generate commit msg and follow this format 

Short Summary. 
- [Module][plugin-name][add/remove/update] desc
- [Module][plugin-name][add/remove/update] desc
]],
            },
            {
              role = "user",
              contains_code = true,
              content = function()
                vim.fn.system("git add .")
                return "Given the git diff listed below, please generate a commit message and put it inside a commit command for me. the commit command should be at your answers very last:\n\n"
                  .. "```\n"
                  .. vim.fn.system("git diff --staged")
                  .. "\n```"
                -- remove my manual commit step
              end,
            },
          },
        },
      },
      display = {
        -- diff = {
        --   -- provider = "mini_diff",
        -- },
      },
      keymaps = {
        send = {
          modes = {
            n = { "<CR>", "<C-s>" },
            i = "<C-s>",
          },
          index = 1,
          callback = "keymaps.send",
          description = "Send",
        },
      },
    }

    require("codecompanion").setup(opts)
  end,
}
