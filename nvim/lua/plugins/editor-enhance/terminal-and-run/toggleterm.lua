---new a toggleterm
---@param cmd string?
---@param name string?
---@param direction? 'vertical' | 'horizontal' | 'tab' | 'float'
---@param size number? -- size seems like not working, Terminal:new args don't have size
---@return Terminal # toggleterm Terminal type
local function new_term(cmd, name, direction, size)
  -- local function new_term(cmd, name, direction, size)
  cmd = cmd or "zsh"
  name = name or (cmd:sub(1, 1):upper() .. cmd:sub(2))
  direction = direction or "float"
  size = size or 20

  local Terminal = require("toggleterm.terminal").Terminal
  local created_term = Terminal:new({
    size = size,
    cmd = cmd,
    dir = "git_dir",
    name = name,
    display_name = name,
    direction = direction,
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
      vim.api.nvim_buf_set_keymap(0, "t", "q", "<cmd>close<CR>", { silent = false, noremap = true })
      if vim.fn.mapcheck("q", "t") ~= "" then
        vim.api.nvim_buf_del_keymap(term.bufnr, "t", "q")
      end

      vim.cmd("startinsert!")
    end,
    -- function to run on closing the terminal
    on_close = function(_)
      vim.cmd("startinsert!")
    end,
  })
  return created_term
end

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({ size = 20 })

    -- TODO: Aider not working inside neovim's terminal
    -- local aider = new_term("aider --model sonnet", "Aider", "vertical", 10)
    -- vim.keymap.set({ "n", "v", "t" }, "<C-m>", function()
    --   aider:toggle()
    -- end, {})

    vim.keymap.set("n", "<M-3>", "<cmd>ToggleTerm name=base<cr>")
    vim.keymap.set("n", "<D-3>", "<cmd>ToggleTerm name=base<cr>")
    vim.keymap.set("n", "<leader>sl", ":ToggleTermSendCurrentLine<cr>")
    vim.keymap.set("v", "<leader>sk", ":ToggleTermSendVisualLines<cr>")
  end,
}
