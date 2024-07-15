local config = require('Hints.config')
local window = require('Hints.window')
local key_handling = require('Hints.key_handling')
local M = {}

---@param opts HintsSettings
function M.setup(opts)
  config.set(opts)

  ---Add a key to get hints for
  ---@param key string
  function M.add_hint_key(key)
    vim.keymap.set('n', config.hint_leader .. key, function()
      window.hint_window(key)
    end, { desc = 'Hints for ' .. key_handling.map_special_names(key) .. ' key' })
  end

  ---Show the hint window for this key
  ---@param lead string
  function M.hint(lead)
    window.hint_window(lead)
  end

  print(#config.hint_keys)
  for i, key in ipairs(config.hint_keys) do
    M.add_hint_key(key)
  end

  vim.keymap.set('n', config.hint_leader .. config.clear_mapping, function()
    window.close_window()
  end, { desc = 'Close Hint Window' })

  vim.api.nvim_create_user_command('Hint', function(value)
    key_handling.get_all_keymaps_starting_with(value.fargs[1]):map(function(val)
      print("'" .. val.lhs .. "'   " .. tostring(val.desc))
    end)
  end, {
    desc = 'Show description of keymap',
    nargs = 1,
    complete = function(argLead, _, _)
      return key_handling.get_all_keymaps_starting_with(argLead):totable()
    end
  })


  ---Get the current configuration
  ---@return HintsSettings
  function M.get_config()
    return config.get()
  end
end

return M
