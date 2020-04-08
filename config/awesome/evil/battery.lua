local gears = require("gears")
local awful = require("awful")

local cmd = "cat /sys/class/power_supply/BAT1/capacity"

gears.timer {
    timeout   = 20,
    call_now  = true,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async(
            cmd,
            function(stdout)
                local capacity = stdout:match("^%s*(.-)%s*$")
                awesome.emit_signal("evil::battery", tonumber(capacity))
            end
        )
    end
}
