local log = require("util.log")

local run_selected = function()
  local editor = require("util.editor")
  local sys = require("util.base.sys")
  local stringUtil = require("util.base.strings")
  local selected = editor.buf.read.get_selected()
  local stdout, _, stderr = sys.run_sync(stringUtil.split_cmd_string(selected), ".")
  local result = stdout or stderr
  editor.buf.write.put_lines(result, "l", true, true)
  pcall(sys.copy_to_system_clipboard, stringUtil.join(result, "\n"))
end
vim.keymap.set({ "n", "v" }, "<leader>rk", run_selected)
vim.api.nvim_create_user_command("RunSelected", run_selected, {})

local function cd_to_buffer_location()
  local editor = require("util.editor")
  local cmd = "cd " .. editor.buf.read.get_buf_abs_dir_path()
  local terminal = editor.get_first_visible_terminal()
  if not terminal then
    return log.error("No visible terminal found")
  end
  editor.buf.write.send_to_terminal_buf(terminal.id, cmd)
  vim.cmd([[TmuxNavigateDown]])
  vim.cmd([[norm! i]])
end
vim.keymap.set({ "n", "v" }, "<leader>so", cd_to_buffer_location)

local function run_current_file()
  local cmd = function()
    if vim.bo.ft == "javascript" then
      vim.cmd([[!node %]])
    elseif vim.bo.ft == "html" then
      vim.cmd([[!open %]])
    end
  end

  vim.keymap.set({ "n", "v" }, "<M-r>", cmd)
  vim.keymap.set({ "n", "v" }, "<D-r>", cmd)
  vim.api.nvim_create_user_command("RunFile", cmd, {})
end
run_current_file()

-- local function popup_terminal()
--   require("toggleterm.terminal").Terminal
--     :new({
--       dir = "git_dir",
--       direction = "float",
--       float_opts = {
--         border = "double",
--       },
--       -- function to run on opening the terminal
--       on_open = function(term)
--         vim.cmd("startinsert!")
--         vim.api.nvim_buf_set_keymap(
--           term.bufnr,
--           "n",
--           "q",
--           "<cmd>close<CR>",
--           { noremap = true, silent = true }
--         )
--         vim.keymap.set({ "n", "v" }, "<M-w>", function()
--           term:shutdown()
--         end, { noremap = true, silent = true, buffer = term.bufnr })
--       end,
--       -- function to run on closing the terminal
--       on_close = function(term)
--         vim.api.nvim_buf_delete(term.bufnr, { force = true })
--         vim.cmd("startinsert!")
--       end,
--     })
--     :toggle()
-- end
--
-- REF: https://github.com/AstroNvim/astrocommunity/blob/d64d788e163f6d759e8a1adf4281dd5dd2841a78/lua/astrocommunity/terminal-integration/toggleterm-manager-nvim/init.lua
-- if you only want these mappings for toggle term use term://*toggleterm#* instead
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<C-[>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set("t", "<C-t>", [[<C-\><C-n><C-t>]], opts)
  vim.keymap.set("t", "<M-w>", [[<Cmd>wincmd c<CR>]], opts)
  vim.keymap.set("t", "<M-3>", [[<C-\><C-n><M-3>]], opts) -- toggle disposable terminal
  vim.keymap.set("t", "<D-w>", [[<Cmd>wincmd c<CR>]], opts)
  vim.keymap.set("t", "<D-3>", [[<C-\><C-n><M-3>]], opts) -- toggle disposable terminal
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

return { import = "plugins.editor-enhance.terminal-and-run" }
