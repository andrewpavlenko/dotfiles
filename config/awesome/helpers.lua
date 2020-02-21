local gears = require("gears")
local wibox = require("wibox")

local helpers = {}

helpers.rrect = function(radius)
  return function(c, width, height)
    gears.shape.rounded_rect(c, width, height, radius)
  end
end

helpers.colorize_text = function(text, color)
    return "<span foreground='" .. color .."'>" .. text .. "</span>"
end

helpers.pwrline_wrap = function(widget, symbol, bg, bg_next)
  local w = wibox.widget {
    {
        {
          markup = helpers.colorize_text(symbol, bg),
          font = "Ubuntu Nerd Font Medium 14",
          widget = wibox.widget.textbox,
        },
        bg     = bg_next,
        widget = wibox.container.background,
    },
    {
        wibox.container.margin(widget, 5, 5),
        bg     = bg,
        widget = wibox.container.background,
    },
    layout = wibox.layout.fixed.horizontal(),
  }

  return w
end

return helpers
