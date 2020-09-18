local naughty = require("naughty")
local awful = require("awful")
local beautiful = require("beautiful")

naughty.config.padding = beautiful.notification_padding
naughty.config.spacing = beautiful.notification_spacing
naughty.config.defaults.margin = beautiful.notification_margin
naughty.config.defaults.border_width = beautiful.notification_border_width

naughty.config.presets.critical = {
    bg = beautiful.xcolor1,
    fg = beautiful.xbackground,
    timeout = 0
}

-- Notify when keyboard layout changes
local keyboard_notification = {}
local dummy_keyboardlayout_widget = awful.widget.keyboardlayout()
dummy_keyboardlayout_widget:connect_signal("widget::redraw_needed", function ()
    keyboard_notification = naughty.notify({title = "Keyboard layout", text = dummy_keyboardlayout_widget.widget.text:upper():gsub("^%s*(.-)%s*$", "%1"), timeout = 1, replaces_id = keyboard_notification.id})
end)

-- naughty.notify({title = "Fuck", text = "You", timeout = 0})
-- naughty.notify({title = "Fuck", text = "You", timeout = 0})
-- naughty.notify({title = "Fuck", text = "You", preset = naughty.config.presets.critical})
