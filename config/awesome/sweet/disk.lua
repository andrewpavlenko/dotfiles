local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local textbox = wibox.widget.textbox("")
textbox.font = beautiful.nerd_font

local disk = awful.widget.watch("df /dev/sda1 -BG --output=avail", 60, function(widget, stdout)
  local out = stdout:match("(%d+%a+)")
  local text = " "..out.."B"
  widget.text = text
end, textbox)

return disk
