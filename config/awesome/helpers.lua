local gears = require("gears")

local helpers = {}

helpers.rrect = function(radius)
  return function(c, width, height)
    gears.shape.rounded_rect(c, width, height, radius)
  end
end

return helpers
