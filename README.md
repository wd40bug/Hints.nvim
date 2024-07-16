<p align="center">
  <img src="https://github.com/user-attachments/assets/ce9512b2-32c4-4964-a4e9-438b719d2832"/>
</p>

<h1 align="center">Hints.nvim</h1>
<p align="center">Plugin for helping you remember all your keybinds</p>

## Install
**Lazy.nvim**
```lua
{'wd40bug/Hints.nvim},
```

**Packer**
```lua
use {'wd40bug/Hints.nvim'}
```
**Vim-Plug**
```lua
Plug 'wd40bug/Hints.nvim'
```

## Setup
```lua
require("Hints").setup({
  hint_keys = {keys_to_provide_hints_for}
})
```
## Configuration
Optionally you may configure the program with the setup function. 
Provided is the default configuration
```lua
require("Hints").setup( {
  
  max_width = 50, -- number: Maximum width of the hint window. Descriptions that go beyond this will be truncated and can be accessed with `:Hint lhs`

  hint_leader = 'f', -- string: Leader for hints, when pressed before a key in hint_keys will show the hint dialogue for that key

  special_names = { [" "]= "<Space>" }, -- dict: Special names for keys like space which don't display nicely

  hint_keys = {}, -- string[]: Keys to provide hints for

  clear_mapping = "/", -- string: Close hint window on pressing `hint_leader`+`clear_mapping`
  
})
```
