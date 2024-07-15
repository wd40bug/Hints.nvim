local M = {}


---@class HintsSettings
---@field max_len number Maximum length of text in the hint window
---@field hint_leader string If pressed before a key in `hint_keys`, shows help text for that key
---@field special_names {[string]: string} Whenever lhs would be printed, replace with rhs
---@field hint_keys string[] Keys to provide hints for
---@field clear_mapping string Mapping to close hint window (will be prepended with the hint_leader automatically)
local DEFAULT_SETTINGS = {
  max_len = 50,

  hint_leader = 'f',

  special_names = { [" "]= "<Space>" },

  hint_keys = {vim.g.mapleader},

  clear_mapping = "/",
  
}

local config = DEFAULT_SETTINGS

---Set config from user opts
---@param opts HintsSettings
function M.set(opts)
  print(vim.inspect(config.hint_keys))
  config = vim.tbl_deep_extend("force", config, opts)
  print(vim.inspect(config.hint_keys))
  table.insert(config.hint_keys, config.hint_leader)
end

function M.default()
  return DEFAULT_SETTINGS
end

---Get values of the config
---@return HintsSettings
function M.get()
  return config
end

---@type HintsSettings
M = setmetatable(M, {
  __index = function(_, k) return config[k] end
})

return M
