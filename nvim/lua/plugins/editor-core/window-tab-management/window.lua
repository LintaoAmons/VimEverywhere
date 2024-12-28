local function zen_mode()
  vim.keymap.set("n", "<leader>zz", ":lua Snacks.zen()<cr>")
end
zen_mode()

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

local function close_window_or_buffer()
  local closeWindowOrBuffer = function()
    local isOk, _ = pcall(vim.cmd, "close")

    if not isOk then
      vim.cmd("bd")
    end
  end
  vim.keymap.set("n", "<M-w>", closeWindowOrBuffer)
end
close_window_or_buffer()

local maxmise_windows = function()
  require("util.editor").window.close_all_other_windows({
    "filesystem", -- neo-tree
    "Trouble",
    "term",
  })
end
vim.keymap.set("n", "<leader>wo", maxmise_windows)

local function maxmise_windows_all()
  local cmd = function()
    require("util.editor").window.close_all_other_windows({})
  end
  vim.keymap.set("n", "<leader>wO", cmd)
end
maxmise_windows_all()

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

vim.keymap.set({ "n", "v", "i" }, "<C-h>", "<cmd>" .. "TmuxNavigateLeft" .. "<cr>")
vim.keymap.set({ "n", "v", "i" }, "<C-l>", "<cmd>" .. "TmuxNavigateRight" .. "<cr>")
vim.keymap.set({ "n", "v", "i" }, "<C-j>", "<cmd>" .. "TmuxNavigateDown" .. "<cr>")
vim.keymap.set({ "n", "v", "i" }, "<C-k>", "<cmd>" .. "TmuxNavigateUp" .. "<cr>")

local function resize_window()
  vim.keymap.set("n", "<C-M-l>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
  vim.keymap.set("n", "<C-M-h>", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })
  vim.keymap.set("n", "<C-M-j>", "<cmd>resize -5<cr>", { desc = "Increase window height" })
  vim.keymap.set("n", "<C-M-k>", "<cmd>resize +5<cr>", { desc = "Decrease window height" })
end
resize_window()
