local naughty = require("naughty")
local beautiful = require("beautiful")

local battery_low_threshold = 15
local battery_low_notified = false

naughty.config.padding = beautiful.notification_padding
naughty.config.spacing = beautiful.notification_spacing
naughty.config.defaults.margin = beautiful.notification_margin

naughty.config.presets.normal = {
    border_width = beautiful.notification_border_width
}

naughty.config.presets.critical = {
    bg = beautiful.notification_critical_bg,
    fg = beautiful.notification_critical_fg,
    timeout = 0,
    border_width = beautiful.notification_border_width
}

awesome.connect_signal("evil::battery", function(capacity)
    if capacity < battery_low_threshold and not battery_low_notified then
        naughty.notify({
            title = "Battery is low!",
            text = "Please, connect the charger.",
            timeout = 0,
            icon = beautiful.icon_battery_low,
            icon_size = beautiful.notification_icon_size
        })
        battery_low_notified = true
    elseif capacity > battery_low_threshold then
        battery_low_notified = false
    end
end)
