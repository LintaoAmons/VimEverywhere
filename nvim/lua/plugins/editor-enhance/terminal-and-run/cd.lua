local log = require("util.log")

local function cd_to_buffer_project_root()
  local editor = require("util.editor")
  local project_path = editor.find_project_path()
  if not project_path then
    project_path = editor.buf.read.get_buf_abs_dir_path()
  end
  local cmd = "cd " .. project_path
  local terminal = editor.get_first_visible_terminal()
  if not terminal then
    return log.error("No visible terminal found")
  end
  editor.buf.write.send_to_terminal_buf(terminal.id, cmd)
  vim.cmd([[TmuxNavigateDown]])
  vim.cmd([[norm! i]])
end
vim.keymap.set({ "n", "v" }, "<leader>si", cd_to_buffer_project_root)

local function cd_to_buffer_dir()
  local editor = require("util.editor")
  local dir = editor.buf.read.get_buf_abs_dir_path()
  local cmd = "cd " .. dir
  local terminal = editor.get_first_visible_terminal()
  if not terminal then
    vim.notify("No visible terminal found", vim.log.levels.ERROR)
    return
  end
  editor.buf.write.send_to_terminal_buf(terminal.id, cmd)
  vim.cmd([[TmuxNavigateDown]])
  vim.cmd([[norm! i]])
end
vim.keymap.set({ "n", "v" }, "<leader>so", cd_to_buffer_dir)

return {}
