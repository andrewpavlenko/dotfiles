local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local textbox = wibox.widget.textbox("")
textbox.font = beautiful.nerd_font

local disk = awful.widget.watch("df /dev/sda1 --output=pcent", 60, function(widget, stdout)
  local out = stdout:match("(%d+)%%")
  local text = " "..out.." %"
  widget.text = text
end, textbox)

return disk
