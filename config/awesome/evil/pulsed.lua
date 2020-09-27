local awful = require("awful")
local volume = require("volume")
-- local naughty = require("naughty")

local function onstdout(out)
    if out:match("Event 'change' on sink #0") then
        volume.get_volume_state(function(vol, mute)
            awesome.emit_signal("evil::volume", vol, mute)
        end)
    end
end

awful.spawn.with_line_callback("pactl subscribe", {stdout = onstdout})
