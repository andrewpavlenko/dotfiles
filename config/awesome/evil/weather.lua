local gears = require("gears")
local awful = require("awful")
local json = require("utils.json")

local location = secrets.location

local cmd = "curl https://api.darksky.net/forecast/"..secrets.darksky_key.."/"..location.lat..","..location.lon.."?exclude=flags,alerts,daily,hourly,minutely&units=auto"

gears.timer {
    timeout   = 300,
    call_now  = true,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async(
            cmd,
            function(out)
                if out:match("currently") then
                    local response = json.decode(out)
                    local summary = response.currently.summary
                    local temperature = math.floor(response.currently.temperature + 0.5)
                    awesome.emit_signal("evil::weather", temperature, summary)
                end
            end
        )
    end
}
