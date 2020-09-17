local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")

local step = 5

local volume = {}

volume.get_volume_state = function(cb)
  awful.spawn.easy_async("pactl list sinks", function(stdout)
    local mute = stdout:match("Mute:%s+(%a+)")
    local volume = stdout:match("%s%sVolume:[%s%a-:%d/]+%s(%d+)%%")

    if mute == "yes" then
      mute = true
    else
      mute = false
    end

    volume = tonumber(volume)

    cb(volume, mute)
  end)
end

volume.volume_up = function()
  volume.get_volume_state(function(vol, mute)
    local next_vol = vol + step

    if (next_vol > 100) then
      next_vol = 100
    end

    os.execute("pactl set-sink-volume @DEFAULT_SINK@ "..next_vol.."%")
    awesome.emit_signal("evil::volume", next_vol, mute)
  end)
end

volume.volume_down = function()
  volume.get_volume_state(function(vol, mute)
    local next_vol = vol - step

    if (next_vol < 0) then
      next_vol = 0
    end

    os.execute("pactl set-sink-volume @DEFAULT_SINK@ "..next_vol.."%")
    awesome.emit_signal("evil::volume", next_vol, mute)
  end)
end

volume.volume_mute = function()
  volume.get_volume_state(function(vol, mute)
    local next_mute = mute and 0 or 1
    local next_mute_bool = not mute
    os.execute("pactl set-sink-mute @DEFAULT_SINK@ "..next_mute)
    awesome.emit_signal("evil::volume", vol, next_mute_bool)
  end)
end

return volume
