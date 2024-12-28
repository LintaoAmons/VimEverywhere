local function base_term_init()
  local new_base_term = function()
    return require("toggleterm.terminal").Terminal:new({
      display_name = "Base",
      count = 1,
      direction = "horizontal",
      dir = vim.fn.expand("%:p:h"),
      auto_scroll = true, -- automatically scroll to the bottom on terminal output
    })
  end
  new_base_term():spawn()
  return new_base_term
end

---init tui tool toggleterm
---@param tui_tool string
---@param name string?
local function tui_tool_init(tui_tool, name)
  local Terminal = require("toggleterm.terminal").Terminal
  local tui_term = Terminal:new({
    cmd = tui_tool,
    dir = "git_dir",
    direction = "float",
    float_opts = {
      border = "double",
    },
    -- function to run on opening the terminal
    on_open = function(term)
      -- https://github.com/akinsho/toggleterm.nvim/issues/34
      vim.api.nvim_buf_set_keymap(
        0,
        "t",
        "<esc>",
        "<cmd>close<CR>",
        { silent = false, noremap = true }
      )
      if vim.fn.mapcheck("<esc>", "t") ~= "" then
        vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
      end
      vim.api.nvim_buf_set_keymap(
        0,
        "t",
        "q",
        "<cmd>close<CR>",
        { silent = false, noremap = true }
      )
      if vim.fn.mapcheck("q", "t") ~= "" then
        vim.api.nvim_buf_del_keymap(term.bufnr, "t", "q")
      end

      vim.cmd("startinsert!")

    end,
    -- function to run on closing the terminal
    on_close = function(term)
      vim.cmd("startinsert!")
    end,
  })

  name = name or (tui_tool:sub(1, 1):upper() .. tui_tool:sub(2))
  vim.api.nvim_create_user_command("Toggle" .. name, function()
    tui_term:toggle()
  end, {})
end

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({ size = 20 })
    local new_base_term = base_term_init()
    tui_tool_init("htop")
    tui_tool_init("lazydocker")
    tui_tool_init("k9s")

    local function toggle_term()
      local all = require("toggleterm.terminal").get_all(true)
      if #all == 0 then
        new_base_term():toggle()
      else
        vim.cmd("ToggleTermToggleAll")
      end
    end

    vim.keymap.set("n", "<M-3>", toggle_term)
    vim.keymap.set("n", "<leader>sl", ":ToggleTermSendCurrentLine<cr>")
    vim.keymap.set("v", "<leader>sk", ":ToggleTermSendVisualSelection<cr>")
  end,
}
