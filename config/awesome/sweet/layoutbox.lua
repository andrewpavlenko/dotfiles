local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

local function layoutbox(screen)
  local name = awful.layout.getname(screen.selected_tag.layout)
  local textbox = wibox.widget.textbox(name)
  local widget = wibox.widget {
      {
          textbox,
          left = 5,
          right = 5,
          widget = wibox.container.margin
      },
      bg = "#ffffff",
      widget = wibox.container.background
  }

  widget:buttons(gears.table.join(
                         awful.button({ }, 1, function () awful.layout.inc( 1) end),
                         awful.button({ }, 3, function () awful.layout.inc(-1) end),
                         awful.button({ }, 4, function () awful.layout.inc( 1) end),
                         awful.button({ }, 5, function () awful.layout.inc(-1) end)))

  awful.tag.attached_connect_signal(screen, "property::layout", function(t)
    local name = awful.layout.getname(t.layout)
    textbox.text = name
  end)
  awful.tag.attached_connect_signal(screen, "property::selected", function(t)
    local name = awful.layout.getname(t.layout)
    textbox.text = name
  end)

  return widget
end

return layoutbox
