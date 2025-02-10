local function split_vertically()
  local cmd = function()
    if vim.bo.buftype == "terminal" then
      local Terminal = require("toggleterm.terminal").Terminal
      Terminal:new({}):toggle()
    else
      vim.cmd("rightbelow vsplit")
    end
  end
  vim.keymap.set("n", "<leader>wl", cmd)
  vim.api.nvim_create_user_command("SplitVertically", cmd, {})
end
split_vertically()

local function split_horizontally()
  local cmd = "split"
  vim.api.nvim_create_user_command("SplitHorizontally", cmd, {})
end
split_horizontally()

local function close_or_hide_window()
  local closeWindowOrBuffer = function()
    -- tring to close the window
    local isOk, _ = pcall(vim.cmd, "close")

    -- if can't close the window then hide the window
    if not isOk then
      vim.cmd("hide")
    end
  end
  vim.keymap.set("n", "<M-w>", closeWindowOrBuffer)
  vim.keymap.set({ "n", "i" }, "<D-w>", closeWindowOrBuffer)
end
close_or_hide_window()

local function close_other_windows()
  local cmd = function()
    require("util.editor").window.close_all_other_windows({})
  end
  vim.keymap.set("n", "<leader>wo", cmd)
  vim.api.nvim_create_user_command("CloseOtherWindows", cmd, {})
end
close_other_windows()

local function open_buffer_in_new_tab()
  local cmd = function()
    -- Get the current buffer number before creating new tab
    local current_buf = vim.api.nvim_get_current_buf()
    -- Create a new tab
    vim.cmd("tabnew")
    -- Set the new tab's buffer to the saved buffer
    vim.api.nvim_win_set_buf(0, current_buf)
  end

  -- Add keymap and command
  vim.keymap.set("n", "<leader>wp", cmd, { desc = "Open buffer in new tab" })
  vim.api.nvim_create_user_command("OpenBufferInNewTab", cmd, {})
end
open_buffer_in_new_tab()

local function flash_window()
  -- Save the current background highlight
  local current_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg or "#000000"

  -- Create highlight group for flash effect with desaturated warm color
  vim.api.nvim_set_hl(0, "WindowFlash", { bg = "#363230" }) -- Desaturated warm gray

  -- Create a namespace for the flash effect
  local ns = vim.api.nvim_create_namespace("window_flash")
  vim.api.nvim_set_hl(ns, "Normal", { bg = "#363230" }) -- Same desaturated warm gray

  -- Apply flash highlight to current window
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_hl_ns(win, ns)

  -- Reset after brief delay
  vim.defer_fn(function()
    vim.api.nvim_win_set_hl_ns(win, 0)
  end, 100)
end

vim.keymap.set({ "n", "v", "i" }, "<C-h>", function()
  vim.cmd("TmuxNavigateLeft")
  flash_window()
end)

vim.keymap.set({ "n", "v", "i" }, "<C-l>", function()
  vim.cmd("TmuxNavigateRight")
  flash_window()
end)

vim.keymap.set({ "n", "v", "i" }, "<C-j>", function()
  vim.cmd("TmuxNavigateDown")
  flash_window()
end)

vim.keymap.set({ "n", "v", "i" }, "<C-k>", function()
  vim.cmd("TmuxNavigateUp")
  flash_window()
end)

local function resize_window()
  vim.keymap.set("n", "<C-M-l>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
  vim.keymap.set("n", "<C-M-h>", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })
  vim.keymap.set("n", "<C-M-j>", "<cmd>resize -5<cr>", { desc = "Increase window height" })
  vim.keymap.set("n", "<C-M-k>", "<cmd>resize +5<cr>", { desc = "Decrease window height" })
  vim.keymap.set("n", "<C-D-l>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
  vim.keymap.set("n", "<C-D-h>", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })
  vim.keymap.set("n", "<C-D-j>", "<cmd>resize -5<cr>", { desc = "Increase window height" })
  vim.keymap.set("n", "<C-D-k>", "<cmd>resize +5<cr>", { desc = "Decrease window height" })
end
resize_window()

-- if true then return {} end
return {
  {
    "JoseConseco/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
    },
    config = function()
      require("windows").setup({
        autowidth = {
          enable = true,
          winwidth = 80,
          filetype = {
            help = 2,
          },
        },
        ignore = { --        |windows.ignore|
          buftype = { "quickfix" },
          filetype = {
            "NvimTree",
            "neo-tree",
            "undotree",
            "gundo",
            "BookmarksTree",
            "snacks_picker_list",
          },
        },
        autoheight = {
          enable = false,
        },
        autoboth = { -- will use settings from autowidth sections (for width param) and autoheight section (for height controls)
          enable = false,
        },
      })
    end,
  },
}
