local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local helpers = require("helpers")
local text_taglist = require("taglist")

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

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

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
            mysystray_toggle,
        },
    }
end)
