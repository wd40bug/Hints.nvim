local config = require('Hints.config')
local keys = require('Hints.key_handling')

local M = {}

local window_handle = nil

---Create a hint_window for the provided lead
---@param lead string key to get hints for
function M.hint_window(lead)
  local hint_buf = vim.api.nvim_create_buf(false, true)
  local keymap_iter = keys.get_all_keymaps_starting_with(lead):map(function(v)
    v.lhs = keys.map_special_names(v.lhs); return v
  end)

  local longest_lhs = keymap_iter:fold(0, function(acc, val)
    return math.max(acc, #val.lhs)
  end)

  local keymap_strings = keymap_iter:map( -- Add desc to text and trim to length
    function(value)
      local str = value.lhs .. string.rep(' ', 3 + longest_lhs - #value.lhs) .. tostring(value.desc)
      value.str_len = #str
      --TODO: Why was this minus 3?
      if value.str_len > config.max_width then
        str = string.sub(str, 1, config.max_width - (10 + longest_lhs)) .. '... :Hint ' .. value.lhs
      end
      value.str = str
      return value
    end
  )

  local keymap_table = keymap_strings:totable()
  -- Get `str` fields as a string[]
  ---@type string[]
  local lines = keymap_strings:fold({}, function (acc, val)
    acc[#acc+1] = val.str
    return acc
  end)
  -- Set buffer text
  vim.api.nvim_buf_set_lines(hint_buf, 0, #keymap_table, false, lines)

  -- Add tags for trimmed options
  -- TODO: Is this even used?
  for i, key in ipairs(keymap_table) do
    if key.str_len > config.max_width - 3 then
      vim.api.nvim_buf_add_highlight(hint_buf, -1, "Tag", i-1, config.max_width - (longest_lhs + 6), -1)
    end
  end

  local longest_line = keymap_strings:map(function(value)  -- get size of text
    return string.len(value.str)
  end):fold(0, function(acc, value)
    acc = math.max(value, acc)
    return acc
  end)


  M.close_window() --Close previous window if it exists
  local title = keys.map_special_names(lead) .. ' Hints'
  local window_width = math.min(math.max(longest_line, #title), config.max_width)
  local ui = vim.api.nvim_list_uis()[1]
  window_handle = vim.api.nvim_open_win(hint_buf, false, {
    relative = 'editor',
    anchor = 'SE',
    width = window_width,
    height = math.max(1, #keymap_table),
    focusable = false,
    style = 'minimal',
    border = 'single',
    title = title,
    title_pos = 'left',
    row = ui.height - 2,
    col = ui.width,
  })

end

function M.close_window()
  if window_handle then
    vim.api.nvim_win_close(window_handle, false)
    window_handle = nil
  end
end

return M
