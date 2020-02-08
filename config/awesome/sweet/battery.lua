local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")

local color = beautiful.sweet_battery_color or "#e06c75"

local textbox = wibox.widget.textbox("")
textbox.font = "Ubuntu Nerd Font 8"

local battery = awful.widget.watch("cat /sys/class/power_supply/BAT1/capacity", 20, function(widget, stdout)
  local text = " " .. stdout
  widget.markup = helpers.colorize_text(text, color)
end, textbox)

local widget = wibox.widget {
    battery,
    left = 5,
    right = 5,
    widget = wibox.container.margin
}

return widget
