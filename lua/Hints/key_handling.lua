local config = require('Hints.config')

local M = {}

---Determines if string begins with start
---@param test string
---@param start string
---@return boolean
local function starts_with(test, start)
  return (string.sub(test, 1,#start) == start)
end

---Get all keymaps starting with each of the strings
---@param ... string
---@return Iter
function M.get_all_keymaps_starting_with(...)
  ---@type vim.api.keyset.keymap[]
  local global_keymaps = vim.api.nvim_get_keymap("n")
  ---@type vim.api.keyset.keymap[]
  local buffer_keymaps = vim.api.nvim_buf_get_keymap(0, "n")

  local args = {...}
  ---@type vim.api.keyset.keymap[]
  local keys = table.move(buffer_keymaps, 1, #buffer_keymaps, #global_keymaps, global_keymaps)

  local keymap_iter = vim.iter(keys):filter(function(value)  -- only get keybinds starting with lead
    for _, start in ipairs(args) do
      if starts_with(value.lhs, start) then
        return true
      end
    end
    return false
  end)
  return keymap_iter

end

---returns the name, replacing it with the special name if one's listed
---@param search_string string
---@return string
function M.map_special_names(search_string)
  for to_replace, replacement in pairs(config.special_names) do
    if string.find(search_string, to_replace) then
      local change, _ = search_string:gsub(to_replace:gsub('[%(%)%.%%%+%-%*%?%[%]%^%$]', '%%%0'), replacement) 
      return change
    end
  end
  return search_string
end

return M
