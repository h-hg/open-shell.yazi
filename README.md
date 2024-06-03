# Open-Shell.yazi

A simple [Yazi](https://github.com/sxyazi/yazi) plugin inpirated from [dropping-to-shell](https://yazi-rs.github.io/docs/tips/#dropping-to-shell) supports opening shell here.

## Installation

```sh
# Linux/macOS
git clone https://github.com/h-hg/open-shell.yazi.git ~/.config/yazi/plugins/open-shell.yazi

# Windows
git clone https://github.com/h-hg/open-shell.yazi.git $env:APPDATA\yazi\config\plugins\open-shell.yazi
```

## Usage

You can configure with the following settings in `init.lua`.

```lua
require("open-shell"):setup {
  -- Optional, the default shell in Windows is cmd.exe, $SHELL in UNIX
  shell = -- Your shell
}
```

You can also choose the shell based on the system.

```lua
-- Choose the shell based on the system type
local get_command_path = function(command)
  local shell = ya.target_family() == "windows" and "where %s" or "command -v %s"
  local f = io.popen(string.format(shell, command), "r")
  local ret = ""
  if f ~= nil then
    ret = f:read("*a"):match("^%s*(.-)%s*$")
    f:close()
  end
  if #ret == 0 then
    return nil
  else
    return ret
  end
end

local shell = ""
if ya.target_family() == "windows" then
  shell = get_command_path("pwsh") or get_command_path("powershell") or os.getenv("ComSpec")
else
  shell = os.getenv("SHELL")
end
shell = '"' .. shell .. '"'

require("open-shell"):setup {
  shell = shell
}
```

You can configure the keymap as shown below.

```toml
[[manager.prepend_keymap]]
on   = [ "<C-s>" ]
run  = "plugin open-shell"
desc = "Open shell here"

# other CLI
[[manager.prepend_keymap]]
on   = [ "<C-g>" ]
run  = "plugin open-shell --args=lazygit"
desc = "Open lazygit here"
```
