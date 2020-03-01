local awful = require("awful")
-- local naughty = require("naughty")

local function onstdout(out)
    if out:match("HEADPHONE") then
        awesome.emit_signal("acpi::headphones")
    end
end

awful.spawn.with_line_callback("acpi_listen", {stdout = onstdout})
