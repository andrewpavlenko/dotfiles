local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")

local textbox = wibox.widget.textbox("")
textbox.font = beautiful.nerd_font

local battery = awful.widget.watch("cat /sys/class/power_supply/BAT1/capacity", 20, function(widget, stdout)
  local text = " " .. stdout
  widget.text = text
end, textbox)

return battery
