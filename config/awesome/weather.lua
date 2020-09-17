local gears = require("gears")
local awful = require("awful")
local json = require("json")

local cmd = "curl api.openweathermap.org/data/2.5/weather?lat="..secrets.lat.."&lon="..secrets.lon.."&appid="..secrets.openweather_key.."&units=metric"

gears.timer {
    timeout   = 300,
    call_now  = true,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async(
            cmd,
            function(out)
                if out:match("weather") then
                    local response = json.decode(out)
                    local description = response.weather[1].description
                    local icon_code = response.weather[1].icon
                    local temperature = tonumber(response.main.temp)
                    -- Capitalize first letter of the description
                    description = description:sub(1,1):upper()..description:sub(2)

                    awesome.emit_signal("evil::weather", math.floor(temperature + 0.5), description, icon_code)
                end
            end
        ) --spawn
    end -- callback
} -- timer
