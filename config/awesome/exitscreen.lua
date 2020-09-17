local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
-- local naughty = require("naughty")

local helpers = require("helpers")

-- Appearance
-- icomoon symbols
local icon_font = "icomoon bold 45"
local poweroff_text_icon = ""
local reboot_text_icon = ""
local suspend_text_icon = ""
local exit_text_icon = ""
-- local exit_text_icon = ""
-- local poweroff_text_icon = ""
-- local reboot_text_icon = ""
-- local suspend_text_icon = ""
-- local exit_text_icon = ""
local lock_text_icon = ""

-- Typicons symbols
-- local icon_font = "Typicons 90"
-- local poweroff_text_icon = ""
-- local reboot_text_icon = ""
-- local suspend_text_icon = ""
-- local exit_text_icon = ""
-- local lock_text_icon = ""

local button_bg = beautiful.xcolor0
local button_size = dpi(120)


-- Commands
local poweroff_command = function()
    os.execute("systemctl poweroff")
end
local reboot_command = function()
    os.execute("systemctl reboot")
end
local suspend_command = function()
    lock_screen_show()
    os.execute("systemctl suspend")
end
local exit_command = function()
    awesome.quit()
end
local lock_command = function()
    lock_screen_show()
end

-- Helper function that generates the clickable buttons
local create_button = function(symbol, hover_color, text, command)
    local icon = wibox.widget {
        forced_height = button_size,
        forced_width = button_size,
        align = "center",
        valign = "center",
        font = icon_font,
        text = symbol,
        -- markup = helpers.colorize_text(symbol, color),
        widget = wibox.widget.textbox()
    }

    local button = wibox.widget {
        {
            nil,
            icon,
            expand = "none",
            layout = wibox.layout.align.horizontal
        },
        forced_height = button_size,
        forced_width = button_size,
        shape_border_width = dpi(8),
        shape_border_color = button_bg,
        shape = helpers.rrect(dpi(20)),
        bg = button_bg,
        widget = wibox.container.background
    }

    -- Bind left click to run the command
    button:buttons(gears.table.join(
        awful.button({ }, 1, function ()
            command()
        end)
    ))

    -- Change color on hover
    button:connect_signal("mouse::enter", function ()
        icon.markup = helpers.colorize_text(icon.text, hover_color)
        button.shape_border_color = hover_color
    end)
    button:connect_signal("mouse::leave", function ()
        icon.markup = helpers.colorize_text(icon.text, beautiful.xforeground)
        button.shape_border_color = button_bg
    end)

    return button
end

-- Create the buttons
local poweroff = create_button(poweroff_text_icon, beautiful.xcolor1, "Poweroff", poweroff_command)
local reboot = create_button(reboot_text_icon, beautiful.xcolor6, "Reboot", reboot_command)
local suspend = create_button(suspend_text_icon, beautiful.xcolor5, "Suspend", suspend_command)
local exit = create_button(exit_text_icon, beautiful.xcolor4, "Exit", exit_command)
local lock = create_button(lock_text_icon, beautiful.xcolor3, "Lock", lock_command)

local function screen_mask(s)
    local mask = wibox({visible = false, ontop = true, type = "splash", screen = s})
    awful.placement.maximize(mask)
    mask.bg = beautiful.exit_screen_bg or "#21252b"
    mask.fg = beautiful.exit_screen_fg or "#abb2bf"
    return mask
end

-- Create the exit screen wibox
exit_screen = wibox({visible = false, ontop = true, type = "splash"})
awful.placement.maximize(exit_screen)

exit_screen.bg = beautiful.exit_screen_bg or beautiful.wibar_bg or "#111111"
exit_screen.fg = beautiful.exit_screen_fg or beautiful.wibar_fg or "#FEFEFE"

for s in screen do
    if s == screen.primary then
        s.myexitscreen = exit_screen
    else
        s.myexitscreen = screen_mask(s)
    end

    s.myexitscreen:buttons(gears.table.join(
        -- Left click - Hide exit_screen
        awful.button({ }, 1, function ()
            exit_screen_hide()
        end),
        -- Middle click - Hide exit_screen
        awful.button({ }, 2, function ()
            exit_screen_hide()
        end),
        -- Right click - Hide exit_screen
        awful.button({ }, 3, function ()
            exit_screen_hide()
        end)
    ))
end

local exit_screen_grabber
function exit_screen_hide()
    awful.keygrabber.stop(exit_screen_grabber)
    for s in screen do
        s.myexitscreen.visible = false
    end
end

local keybinds = {
    ['escape'] = exit_screen_hide,
    ['q'] = exit_screen_hide,
    ['x'] = exit_screen_hide,
    ['s'] = function () suspend_command(); exit_screen_hide() end,
    ['e'] = exit_command,
    ['p'] = poweroff_command,
    ['r'] = reboot_command,
    ['l'] = function ()
        lock_command()
        -- Kinda fixes the "white" (undimmed) flash that appears between
        -- exit screen disappearing and lock screen appearing
        gears.timer.delayed_call(function()
            exit_screen_hide()
        end)
    end
}

function exit_screen_show()
    exit_screen_grabber = awful.keygrabber.run(function(_, key, event)
        -- Ignore case
        key = key:lower()

        if event == "release" then return end

        if keybinds[key] then
            keybinds[key]()
        end
    end)
    for s in screen do
        s.myexitscreen.visible = true
    end
end

-- Item placement
exit_screen:setup {
    nil,
    {
        nil,
        {
            poweroff,
            reboot,
            suspend,
            exit,
            lock,
            spacing = dpi(50),
            layout = wibox.layout.fixed.horizontal
        },
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    expand = "none",
    layout = wibox.layout.align.vertical
}
