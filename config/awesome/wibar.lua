local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")
local volume = require("volume")
local text_taglist = require("taglist")

local volume_bar_color = beautiful.xcolor3
local battery_bar_color = beautiful.xcolor1
local ram_bar_color = beautiful.xcolor4

local systray_margin = (beautiful.wibar_height-beautiful.systray_icon_size)/2

local function rounded_bar(color)
    return wibox.widget {
        max_value     = 100,
        value         = 0,
        forced_height = dpi(10),
        forced_width  = dpi(60),
        margins       = {
          top = dpi(10),
          bottom = dpi(10),
        },
        shape         = gears.shape.rounded_bar,
        border_width  = 0,
        color         = color,
        background_color = beautiful.xcolor0,
        border_color  = beautiful.border_color,
        widget        = wibox.widget.progressbar,
    }
end

-- Volume bar
local volume_bar = rounded_bar(volume_bar_color)

function update_volume_bar(vol, mute)
    volume_bar.value = vol
    if mute then
        volume_bar.color = beautiful.xforeground
    else
        volume_bar.color = volume_bar_color
    end
end

volume_bar:buttons(gears.table.join(
    awful.button({ }, 4, volume.volume_up),
    awful.button({ }, 5, volume.volume_down),
    awful.button({ }, 1, volume.volume_mute)))

awesome.connect_signal("evil::volume", update_volume_bar)

-- Init widget state
volume.get_volume_state(update_volume_bar)

-- Update widget when headphones conneted
awesome.connect_signal("acpi::headphones", function()
    volume.get_volume_state(update_volume_bar)
end)

-- Battery bar
local battery_bar = rounded_bar(battery_bar_color)

awful.widget.watch("cat /sys/class/power_supply/BAT1/capacity", 30, function(widget, stdout)
    local capacity = stdout:match("^%s*(.-)%s*$")
    widget.value = tonumber(capacity)
end, battery_bar)

-- Ram bar
local ram_bar = rounded_bar(ram_bar_color)

awful.widget.watch("cat /proc/meminfo", 5, function(widget, stdout)
  local total = stdout:match("MemTotal:%s+(%d+)")
  local free = stdout:match("MemFree:%s+(%d+)")
  local buffers = stdout:match("Buffers:%s+(%d+)")
  local cached = stdout:match("Cached:%s+(%d+)")
  local srec = stdout:match("SReclaimable:%s+(%d+)")
  local used_kb = total - free - buffers - cached - srec
  widget.value = used_kb / total * 100
end, ram_bar)

-- Create systray widget
local mysystray = wibox.widget.systray()
mysystray:set_base_size(beautiful.systray_icon_size)

local mysystray_container = {
    mysystray,
    top = systray_margin,
    bottom = systray_margin,
    widget = wibox.container.margin
}

local textclock = wibox.widget.textclock("%B %d, %A %R")
textclock.font = "Pacifico 11"

-- Weather widget
-- Associate weather icon code with its symbol and color
local weather_icon_map = {}
weather_icon_map["11d"] = { icon = "" }
weather_icon_map["09d"] = { icon = "" }
weather_icon_map["10d"] = { icon = "" }
weather_icon_map["13d"] = { icon = "", color = beautiful.xcolor15 }
weather_icon_map["50d"] = { icon = "" }
weather_icon_map["01d"] = { icon = "", color = beautiful.xcolor3 }
weather_icon_map["01n"] = { icon = "", color = beautiful.xcolor1 }
weather_icon_map["02d"] = { icon = "", color = beautiful.xcolor6 }
weather_icon_map["02n"] = { icon = "", color = beautiful.xcolor1 }
weather_icon_map["03d"] = { icon = "" }
weather_icon_map["03n"] = weather_icon_map["03d"]
weather_icon_map["04d"] = weather_icon_map["03d"]
weather_icon_map["04n"] = weather_icon_map["03d"]

local weather_icon = wibox.widget.textbox("")
weather_icon.font = "Typicons 12"
weather_icon.markup = helpers.colorize_text("", beautiful.xcolor3)
local weather_description = wibox.widget.textbox("")
weather_description.font = "Pacifico 11"
weather_description.text = "N/A"
local weather_widget = {
    weather_icon,
    weather_description,
    layout = wibox.layout.fixed.horizontal,
    spacing = 8
}

-- Update weather widget
awesome.connect_signal("evil::weather", function(temperature, description, icon_code)
    weather_description.text = description.." "..temperature.."°C"
    local icon = weather_icon_map[icon_code].icon
    local color = weather_icon_map[icon_code].color or beautiful.xcolor4
    weather_icon.markup = helpers.colorize_text(icon, color)
end)

awful.screen.connect_for_each_screen(function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, ontop = true })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                spacing = beautiful.wibar_spacing,
                weather_widget,
                textclock,
                s.mypromptbox,
            },
            left = beautiful.wibar_spacing,
            right = beautiful.wibar_spacing,
            widget = wibox.container.margin,
        },
        text_taglist(s), -- Middle widget
        {
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                spacing = beautiful.wibar_spacing,
                mysystray_container,
                volume_bar,
                ram_bar,
                battery_bar,
            },
            left = beautiful.wibar_spacing,
            right = beautiful.wibar_spacing,
            widget = wibox.container.margin,
        },
    }
end)
