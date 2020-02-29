---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gears = require("gears")
local xrdb = xresources.get_current_theme()
local dpi = xresources.apply_dpi

local theme_path = os.getenv("HOME").."/.config/awesome/themes/default/"

local theme = {}

-- Get colors from .Xresources and set fallback colors
theme.xbackground = xrdb.background or "#282F37"
theme.xforeground = xrdb.foreground or "#F1FCF9"
theme.xcolor0     = xrdb.color0     or "#20262C"
theme.xcolor1     = xrdb.color1     or "#DB86BA"
theme.xcolor2     = xrdb.color2     or "#74DD91"
theme.xcolor3     = xrdb.color3     or "#E49186"
theme.xcolor4     = xrdb.color4     or "#75DBE1"
theme.xcolor5     = xrdb.color5     or "#B4A1DB"
theme.xcolor6     = xrdb.color6     or "#9EE9EA"
theme.xcolor7     = xrdb.color7     or "#F1FCF9"
theme.xcolor8     = xrdb.color8     or "#465463"
theme.xcolor9     = xrdb.color9     or "#D04E9D"
theme.xcolor10    = xrdb.color10    or "#4BC66D"
theme.xcolor11    = xrdb.color11    or "#DB695B"
theme.xcolor12    = xrdb.color12    or "#3DBAC2"
theme.xcolor13    = xrdb.color13    or "#825ECE"
theme.xcolor14    = xrdb.color14    or "#62CDCD"
theme.xcolor15    = xrdb.color15    or "#E0E5E5"

theme.font          = "Ubuntu Medium 8"
theme.nerd_font     = "Ubuntu Nerd Font Medium 8"

theme.bg_normal     = theme.xbackground
theme.bg_focus      = theme.xbackground
theme.bg_urgent     = theme.xbackground
theme.bg_minimize   = theme.xbackground
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.xforeground
theme.fg_focus      = theme.xforeground
theme.fg_urgent     = theme.xforeground
theme.fg_minimize   = theme.xforeground

theme.useless_gap   = dpi(5)
theme.border_width  = 0
theme.border_normal = theme.xbackground
theme.border_focus  = theme.xbackground
theme.border_marked = theme.xbackground

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"
theme.taglist_fg_empty = "#5c6370"
theme.taglist_fg_urgent = theme.xcolor4
theme.hotkeys_modifiers_fg = "#5c6370"
theme.lock_screen_bg = theme.xbackground.."DF"
theme.lock_screen_fg = theme.xforeground
theme.sweet_volume_fg = theme.xbackground

theme.wibar_glyph = ""

-- Color of layout icon
theme.layoutbox_fg = theme.xbackground

-- Colors of right widgets bar. Will apply from right to left
theme.powerbar_colors = {
    theme.xforeground,
    "#e7c587",
    "#ec919f",
    "#61afef",
    "#7dbdf1",
    "#9accf4",
    theme.xbackground,
    theme.xbackground,
}

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_padding = dpi(10)
theme.notification_spacing = theme.notification_padding
theme.notification_margin = dpi(10)
theme.notification_border_width = 0
theme.notification_critical_bg = theme.xcolor1
theme.notification_critical_fg = theme.xbackground
theme.notification_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, dpi(6))
end

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme_path.."submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"
theme.maximized_hide_border = true
theme.border_radius = dpi(6)
theme.wibar_height = dpi(22)

-- Define the image to load
theme.wallpaper = theme_path.."wallpaper.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh = theme_path.."layouts/fairhw.png"
theme.layout_fairv = theme_path.."layouts/fairvw.png"
theme.layout_floating  = theme_path.."layouts/floatingw.png"
theme.layout_magnifier = theme_path.."layouts/magnifierw.png"
theme.layout_max = theme_path.."layouts/maxw.png"
theme.layout_fullscreen = theme_path.."layouts/fullscreenw.png"
theme.layout_tilebottom = theme_path.."layouts/tilebottomw.png"
theme.layout_tileleft   = theme_path.."layouts/tileleftw.png"
theme.layout_tile = theme_path.."layouts/tilew.png"
theme.layout_tiletop = theme_path.."layouts/tiletopw.png"
theme.layout_spiral  = theme_path.."layouts/spiralw.png"
theme.layout_dwindle = theme_path.."layouts/dwindlew.png"
theme.layout_cornernw = theme_path.."layouts/cornernww.png"
theme.layout_cornerne = theme_path.."layouts/cornernew.png"
theme.layout_cornersw = theme_path.."layouts/cornersww.png"
theme.layout_cornerse = theme_path.."layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Change layout icons color
theme_assets.recolor_layout(theme, theme.layoutbox_fg)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
