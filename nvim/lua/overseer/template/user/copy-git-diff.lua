---Finds the root directory of the current project by looking for marker files
---@param max_depth? number Maximum directory levels to traverse up (default: 30)
---@param markers? string[] List of marker files/directories to look for (default: {".git", ".gitignore"})
---@return string|nil project_path Returns the project root path or nil if not found
local function find_project_path(max_depth, markers)
  -- Use default values if not provided
  max_depth = max_depth or 30
  markers = markers or vim.g.easy_command_project_root_dir_marker_files or { ".git", ".gitignore" }

  -- Get the current buffer's absolute path
  local current_file = vim.fn.expand("%:p")
  if current_file == "" then
    return nil
  end

  -- Start from the current file's directory
  local current_dir = vim.fn.fnamemodify(current_file, ":h")
  local home_dir = vim.loop.os_homedir()

  -- Traverse up the directory tree
  for i = 1, max_depth do
    -- Check for marker files/directories
    for _, marker in ipairs(markers) do
      local marker_path = current_dir .. "/" .. marker
      if vim.fn.filereadable(marker_path) == 1 or vim.fn.isdirectory(marker_path) == 1 then
        return current_dir
      end
    end

    -- Stop if we reach home directory
    if current_dir == home_dir then
      return nil
    end

    -- Move up one directory
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end

  return nil
end

return {
  name = "copy git diff",
  builder = function()
    local project_path = find_project_path()
    if not project_path then
      return nil
    end

    return {
      cmd = { "git" },
      args = { "diff" },
      cwd = project_path,
      components = {
        {
          "on_output_quickfix",
          open = true,
        },
        {
          "on_complete_notify",
          on_complete = function(task, status, result)
            if status == "SUCCESS" then
              vim.fn.setreg("+", table.concat(result.output, "\n"))
              vim.notify("Git diff copied to clipboard", vim.log.levels.INFO)
            end
          end,
        },
        "default",
      },
    }
  end,
  condition = {
    -- filetype = { "cpp" },
  },
}
