local function get_selected_positions()
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "" then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
    if mode == "V" then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
    local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
    vim.api.nvim_feedkeys(esc, "x", false)
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  end
  -- swap vars if needed
  if cerow < csrow then
    csrow, cerow = cerow, csrow
  end
  if cecol < cscol then
    cscol, cecol = cecol, cscol
  end

  return {
    { row = csrow, col = cscol },
    { row = cerow, col = cecol },
  }
end

local function wrap_in_codeblock()
  -- Get the start and end lines of visual selection
  local location = get_selected_positions()
  local start_line = location[1].row
  local end_line = location[2].row

  -- Insert ``` after the selected block first (to avoid line number changes)
  vim.api.nvim_buf_set_lines(0, end_line, end_line, false, { "```" })

  -- Insert ``` before the selected block
  vim.api.nvim_buf_set_lines(0, start_line - 1, start_line - 1, false, { "```" })

  -- Move cursor to the end of the first ```
  vim.api.nvim_win_set_cursor(0, { start_line, 3 })

  local keys = vim.api.nvim_replace_termcodes("A", true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end

-- Add the mapping for visual mode
vim.keymap.set("v", "<leader>sb", wrap_in_codeblock, { noremap = true, silent = true })

return {}
