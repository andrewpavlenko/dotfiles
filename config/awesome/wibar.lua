local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")
local volume = require("volume")
local text_taglist = require("taglist")

-- Volume bar
local volume_bar = wibox.widget {
    max_value     = 100,
    value         = 50,
    forced_height = dpi(10),
    forced_width  = dpi(70),
    margins       = {
      top = dpi(10),
      bottom = dpi(10),
    },
    shape         = gears.shape.rounded_bar,
    border_width  = 0,
    color         = beautiful.xcolor6,
    background_color = beautiful.xcolor0,
    border_color  = beautiful.border_color,
    widget        = wibox.widget.progressbar,
}

local function update_volume_bar(vol, mute)
    volume_bar.value = vol
    if mute then
        volume_bar.color = beautiful.xforeground
    else
        volume_bar.color = beautiful.xcolor6
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

volume.get_volume_state(update_volume_bar)

-- Create systray widget
local mysystray = wibox.widget.systray()
mysystray:set_base_size(20)

local mysystray_popup = awful.popup {
    widget = {
        mysystray,
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
mysystray_toggle.forced_width = 28
mysystray_toggle.align = "center"

mysystray_toggle:buttons(gears.table.join(
    awful.button({}, 1, function() mysystray_popup.visible = not mysystray_popup.visible end)
))

awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

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
        text_taglist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            volume_bar,
            mysystray_toggle,
        },
    }
end)
