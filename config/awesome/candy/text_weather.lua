local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local weather_temperature_symbol = "°C"

local icons = {}
icons["clear-day"] = ""
icons["clear-night"] = ""

local weather = wibox.widget.textbox("")
weather.font = beautiful.nerd_font

awesome.connect_signal("evil::weather", function(temperature, summary, icon)
    local icon = icons[icon] or ""
    local colored_icon = helpers.colorize_text(icon, beautiful.xcolor1)
    weather.markup = colored_icon.." "..summary.." "..temperature..weather_temperature_symbol
end)

return weather
