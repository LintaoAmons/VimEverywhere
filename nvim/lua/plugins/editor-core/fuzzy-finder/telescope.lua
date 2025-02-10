local command5 = "Telescope live_grep"
vim.keymap.set("n", "<leader>ff", "<cmd>" .. command5 .. "<cr>")
vim.api.nvim_create_user_command("LiveGrepInProject", command5, {})

return { -- Fuzzy Finder (files, lsp, etc)
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      "nvim-telescope/telescope-fzf-native.nvim",

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = "make",

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    require("telescope").setup({
      --  All the info you're looking for is in `:help telescope.setup()`
      pickers = {
        live_grep = {
          file_ignore_patterns = { "node_modules", ".git", ".venv" },
          additional_args = function(_)
            return { "--hidden" }
          end,
        },
      },
      defaults = {
        mappings = {
          i = {
            ["<M-w>"] = require("telescope.actions").close,
            ["<D-w>"] = require("telescope.actions").close,
            -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#mapping-c-u-to-clear-prompt
            ["<C-u>"] = false
          },
          n = {
            ["<M-w>"] = require("telescope.actions").close,
            ["<D-w>"] = require("telescope.actions").close,
          },
        },
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    })

    -- Enable Telescope extensions if they are installed
    pcall(require("telescope").load_extension, "fzf")
  end,
}
