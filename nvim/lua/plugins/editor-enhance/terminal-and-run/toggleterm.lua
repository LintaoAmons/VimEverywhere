---new a toggleterm
---@param cmd string?
---@param name string?
---@return Terminal # toggleterm Terminal type
local function new_term(cmd, name)
  cmd = cmd or "zsh"
  name = name or (cmd:sub(1, 1):upper() .. cmd:sub(2))
  local Terminal = require("toggleterm.terminal").Terminal
  local created_term = Terminal:new({
    cmd = cmd,
    dir = "git_dir",
    name = name,
    display_name = name,
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

  vim.api.nvim_create_user_command("ToggleTerm" .. name, function()
    created_term:toggle()
  end, {})
  return created_term
end

---new a named terminal
---@param name string
local function new_named_terminal(name)
  local created_term = new_term(nil, name)
  created_term:toggle()
end

vim.api.nvim_create_user_command("NewNamedTerminal", function()
  vim.ui.input({ prompt = "Enter terminal name: " }, function(input)
    if input then
      new_named_terminal(input)
    end
  end)
end, {})

vim.api.nvim_create_user_command("NewTerminal", function()
  new_term():toggle()
end, {})

vim.keymap.set("n", "<C-\\>", function()
  new_term():toggle()
end, { noremap = true, silent = true })

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({ size = 20 })
    -- local base_term = new_base_term()
    new_term("htop")
    new_term("lazydocker")
    new_term("k9s")
    new_term("lazygit")

    vim.keymap.set("n", "<M-3>", "<cmd>ToggleTerm name=base<cr>")
    vim.keymap.set("n", "<D-3>", "<cmd>ToggleTerm name=base<cr>")
    vim.keymap.set("n", "<leader>sl", ":ToggleTermSendCurrentLine<cr>")
    vim.keymap.set("v", "<leader>sk", ":ToggleTermSendVisualLines<cr>")
  end,
}
