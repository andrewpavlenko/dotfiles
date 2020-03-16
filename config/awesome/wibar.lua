local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")
local volume = require("volume")
local text_taglist = require("taglist")

local volume_bar_color = beautiful.xcolor12
local battery_bar_color = beautiful.xcolor10

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

local function update_volume_bar(vol, mute)
    volume_bar.value = vol
    if mute then
        volume_bar.color = beautiful.xforeground
    else
        volume_bar.color = volume_bar_color
    end
end

volume_bar:buttons(gears.table.join(
    awful.button({ }, 4, function()
        volume.volume_up(update_volume_bar)
    end),
    awful.button({ }, 5, function()
      volume.volume_down(update_volume_bar)
    end),
    awful.button({ }, 1, function()
      volume.volume_mute(update_volume_bar)
    end)))

-- Init widget state
volume.get_volume_state(update_volume_bar)

-- Update widget when headphones conneted
awesome.connect_signal("acpi::headphones", function()
    volume.get_volume_state(update_volume_bar)
end)

-- Battery bar
local battery_bar = rounded_bar(battery_bar_color)

local battery_widget = awful.widget.watch("cat /sys/class/power_supply/BAT1/capacity", 20, function(widget, stdout)
  local out = stdout:match("^%s*(.-)%s*$")
  widget.value = tonumber(out)
end, battery_bar)

-- Create systray widget
local mysystray = wibox.widget.systray()
mysystray:set_base_size(20)

local mytextclock = wibox.widget.textclock(" %R")
mytextclock.font = beautiful.nerd_font

local mysystray_popup = awful.popup {
    widget = {
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(5),
            mytextclock,
            mysystray,
        },
        widget = wibox.container.margin,
        margins = 8
    },
    placement = awful.placement.bottom_right+awful.placement.no_offscreen,
    shape = helpers.rrect(beautiful.border_radius),
    visible = false,
    ontop = true,
}

local mysystray_toggle = wibox.widget.textbox()
mysystray_toggle.font = "Typicons 10"
mysystray_toggle.markup = helpers.colorize_text("", beautiful.xcolor0)
mysystray_toggle.forced_width = dpi(28)
mysystray_toggle.align = "center"

mysystray_toggle:buttons(gears.table.join(
    awful.button({}, 1, function() mysystray_popup.visible = not mysystray_popup.visible end)
))

awful.screen.connect_for_each_screen(function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, ontop = true })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mypromptbox,
        },
        text_taglist(s), -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(10),
                volume_bar,
                battery_widget,
            },
            mysystray_toggle,
        },
    }
end)
