local wibox = require("wibox")

local weather_temperature_symbol = "°C"

local weather = wibox.widget.textbox("")

awesome.connect_signal("evil::weather", function(temperature, summary)
    weather.text = summary.." "..temperature..weather_temperature_symbol
end)

return weather
