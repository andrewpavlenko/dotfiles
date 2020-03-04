local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Create a textclock widget
mytextclock = wibox.widget.textclock(" %R")
mytextclock.font = beautiful.nerd_font

-- Tooltip for textclock widget
local myclock_tooltip = awful.tooltip {
    objects        = { mytextclock },
    timer_function = function()
        return os.date('%A %B %d')
    end,
    delay_show = 1,
}

-- Battery widget
local bat_textbox = wibox.widget.textbox("")
bat_textbox.font = beautiful.nerd_font

local mybattery = awful.widget.watch("cat /sys/class/power_supply/BAT1/capacity", 20, function(widget, stdout)
  local out = stdout:match("^%s*(.-)%s*$")
  local text = " "..out.." %"
  widget.text = text
end, bat_textbox)

-- Ram widget
local ram_textbox = wibox.widget.textbox("")
ram_textbox.font = beautiful.nerd_font

local myram = awful.widget.watch("cat /proc/meminfo", 10, function(widget, stdout)
  local total = stdout:match("MemTotal:%s+(%d+)")
  local free = stdout:match("MemFree:%s+(%d+)")
  local buffers = stdout:match("Buffers:%s+(%d+)")
  local cached = stdout:match("Cached:%s+(%d+)")
  local srec = stdout:match("SReclaimable:%s+(%d+)")

  local used_kb = total - free - buffers - cached - srec
  local used = math.floor(used_kb / 1024 + 0.5)

  local text = " " .. used .. "MB"
  widget.text = text
end, ram_textbox)

myram:buttons(gears.table.join(
    awful.button({ }, 1, function() awful.spawn.with_shell("alacritty -e htop") end)))

-- Disk usage
local disk_textbox = wibox.widget.textbox("")
disk_textbox.font = beautiful.nerd_font

local mydisk = awful.widget.watch("df /dev/sda1 -BG --output=avail", 60, function(widget, stdout)
  local out = stdout:match("(%d+%a+)")
  local text = " "..out.."B"
  widget.text = text
end, disk_textbox)

-- Volume widget
local myvolume = require("volume")

-- System tray
mysystray = wibox.widget.systray()

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ }, 2, function() awful.spawn.with_shell("rofi -show window") end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

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

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, ontop = true })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        nil, -- Middle widget
        { -- Right wigets
            layout = wibox.layout.fixed.horizontal,
            spacing = 5,
            mysystray,
            mydisk,
            myvolume,
            myram,
            mybattery,
            mykeyboardlayout,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
