local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local helpers = require("helpers")

local fg = beautiful.xcolor2
local padding = 5

local function layoutbox(screen)
  local name = awful.layout.getname(screen.selected_tag.layout)
  local textbox = wibox.widget.textbox(name)
  textbox.markup = helpers.colorize_text(name, fg)
  local widget = wibox.widget {
      textbox,
      left = padding,
      right = padding,
      widget = wibox.container.margin
  }

  widget:buttons(gears.table.join(
                         awful.button({ }, 1, function () awful.layout.inc( 1) end),
                         awful.button({ }, 3, function () awful.layout.inc(-1) end),
                         awful.button({ }, 4, function () awful.layout.inc( 1) end),
                         awful.button({ }, 5, function () awful.layout.inc(-1) end)))

  awful.tag.attached_connect_signal(screen, "property::layout", function(t)
    local name = awful.layout.getname(t.layout)
    textbox.markup = helpers.colorize_text(name, fg)
  end)
  awful.tag.attached_connect_signal(screen, "property::selected", function(t)
    local name = awful.layout.getname(t.layout)
    textbox.markup = helpers.colorize_text(name, fg)
  end)

  return widget
end

return layoutbox
