local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")

local color = beautiful.sweet_volume_fg or "#56b6c2"
local color_mute = beautiful.sweet_volume_mute_fg or "#5c6370"
local step = 5

local textbox = wibox.widget.textbox("")
textbox.font = beautiful.nerd_font
textbox.markup = helpers.colorize_text(" 0", color)

local function get_volume_state(cb)
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

local function update_widget(vol, mute)
  local text = " "..vol.." %"
  if mute then
    textbox.markup = helpers.colorize_text(text, color_mute)
  else
    textbox.markup = helpers.colorize_text(text, color)
  end
end

local function volume_up()
  get_volume_state(function(vol, mute)
    local next_vol = vol + step

    if (next_vol > 100) then
      next_vol = 100
    end

    os.execute("pactl set-sink-volume @DEFAULT_SINK@ "..next_vol.."%")
    update_widget(next_vol, mute)
  end)
end

local function volume_down()
  get_volume_state(function(vol, mute)
    local next_vol = vol - step

    if (next_vol < 0) then
      next_vol = 0
    end

    os.execute("pactl set-sink-volume @DEFAULT_SINK@ "..next_vol.."%")
    update_widget(next_vol, mute)
  end)
end

local function volume_mute()
  get_volume_state(function(vol, mute)
    local next_mute = mute and 0 or 1
    local next_mute_bool = not mute
    os.execute("pactl set-sink-mute @DEFAULT_SINK@ "..next_mute)
    update_widget(vol, next_mute_bool)
  end)
end

get_volume_state(update_widget)

awesome.connect_signal("acpi::headphones", function() get_volume_state(update_widget) end)

textbox:buttons(gears.table.join(
    awful.button({ }, 4, volume_up),
    awful.button({ }, 5, volume_down),
    awful.button({ }, 1, volume_mute)))

return textbox
