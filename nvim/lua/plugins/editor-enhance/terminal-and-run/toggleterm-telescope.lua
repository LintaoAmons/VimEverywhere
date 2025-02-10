-- Create custom terminal buffer previewer
local TerminalPreviewer = function()
  local previewers = require("telescope.previewers")
  return previewers.new_buffer_previewer({
    title = "Terminal Preview",
    get_buffer_by_name = function(_, entry)
      return entry.value.bufnr
    end,
    define_preview = function(self, entry)
      local bufnr = entry.value.bufnr
      if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_set_lines(
          self.state.bufnr,
          0,
          -1,
          false,
          { "No terminal buffer content available" }
        )
        return
      end

      -- Get terminal buffer content
      local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, content)

      -- Set buffer options
      vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "terminal")
    end,
  })
end

local function create_term()
  local name = "Terminal"

  local Terminal = require("toggleterm.terminal").Terminal
  local created_term = Terminal:new({
    cmd = nil,
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

  created_term:open()
end

local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")

---@param callback? fun(term, opts): nil
---@param opts? {prompt?: string}
local function pick_terminal(callback, opts)
  callback = callback or function(term, size, direction)
    term:open(size, direction)
  end
  opts = opts or {}

  local function start_picker(_terms)
    pickers
      .new(opts, {
        prompt_title = opts.prompt or "Toggle terms",
        finder = finders.new_table({
          results = _terms,
          entry_maker = function(term)
            local display = term.display_name
            return {
              value = term,
              display = display,
              ordinal = display,
            }
          end,
        }),
        sorter = conf.generic_sorter(opts),
        previewer = TerminalPreviewer(),
        -- previewer = conf.grep_previewer(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selected = action_state.get_selected_entry()
            if selected == nil then
              return
            end
            callback(selected.value)
          end)
          -- <C-x> Go to selection as a split
          -- <C-v> Go to selection as a vsplit
          -- <C-t> Go to selection in a new tab
          actions.select_horizontal:replace(function()
            actions.close(prompt_bufnr)
            local selected = action_state.get_selected_entry()
            if selected == nil then
              return
            end
            callback(selected.value, nil, "horizontal")
          end)

          actions.select_vertical:replace(function()
            actions.close(prompt_bufnr)
            local selected = action_state.get_selected_entry()
            if selected == nil then
              return
            end
            callback(selected.value, nil, "vertical")
          end)

          actions.select_tab:replace(function()
            actions.close(prompt_bufnr)
            local selected = action_state.get_selected_entry()
            if selected == nil then
              return
            end
            callback(selected.value, nil, "tab")
          end)

          map("i", "<c-d>", function()
            actions.close(prompt_bufnr)
            local selected = action_state.get_selected_entry()
            if selected == nil then
              return
            end
            -- Schedule the shutdown and picker refresh
            vim.schedule(function()
              -- Shutdown the selected terminal
              selected.value:shutdown()

              -- Add a small delay before reopening picker
              vim.defer_fn(function()
                local terms = require("toggleterm.terminal")
                local all_terms = terms.get_all()
                if #all_terms > 0 then
                  start_picker(all_terms)
                else
                  vim.notify("No active terminals", vim.log.levels.INFO)
                end
              end, 100) -- 100ms delay
            end)
          end)

          map("i", "<c-n>", function()
            actions.close(prompt_bufnr)
            create_term()
          end)

          map("i", "<c-f>", function()
            actions.close(prompt_bufnr)
            local selected = action_state.get_selected_entry()
            if selected == nil then
              return
            end
            callback(selected.value, nil, "float")
          end)

          map("i", "<c-r>", function()
            local selected = action_state.get_selected_entry()
            if selected == nil then
              return
            end

            actions.close(prompt_bufnr)
            vim.ui.input(
              { prompt = "New terminal name: ", default = selected.value.display_name },
              function(new_name)
                if new_name and new_name ~= "" then
                  selected.value.display_name = new_name
                  selected.value.name = new_name
                  -- Refresh picker with updated names
                  local terms = require("toggleterm.terminal")
                  local all_terms = terms.get_all()
                  start_picker(all_terms)
                end
              end
            )
          end)

          return true
        end,
      })
      :find()
  end

  local terms = require("toggleterm.terminal")
  local all_terms = terms.get_all()
  start_picker(all_terms)
end

vim.keymap.set("n", "<leader>al", function()
  pick_terminal()
end, {})

return {}
