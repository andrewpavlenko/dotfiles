### Dotfiles
![screenshot](screenshot.png)

- OS: Debian
- WM: awesome

#### Needed packages:
- pulseaudio - control volume
- alacritty - terminal
- redshift - night light
- compton (chjj) - window compositor
- scrot - screenshot tool
- rofi - app launcher
- acpid - subscribe acpi events
- cpufrequtils - cpu governor switcher (not used)
- mpd, mpc, ncmpcpp - music player daemon and ncmpcpp client
- nvim - text editor

#### Needed fonts:
- [Pacifico](https://fonts.google.com/specimen/Pacifico)
- [Luckiest Guy](https://fonts.google.com/specimen/Luckiest+Guy)
- [Ubuntu](https://design.ubuntu.com/font/)
- [Typicons](https://github.com/stephenhutchings/typicons.font)
- [Iosevka](https://github.com/be5invis/Iosevka)
- [JetBrains Mono](https://www.jetbrains.com/lp/mono)
- [Icomoon by @elenapan](https://github.com/elenapan/dotfiles)

#### Notes:
The script `copy-dotfiles.sh` is used for copy dotfiles into git working directory. To make this setup work on your system you should copy config files manually.

Awesomewm config folder should contain file `secrets.lua` that is not included in this repository. Here is that file sample contents:
```
secrets = {
    lock_screen_password = "your password",
    openweather_key = "your token here",
    -- Your coords. Used by weather widget to determine your location
    lon = 12.34,
    lat = 12.34
}
```

Also this environment variable should be exported before running awesome
```
export AWESOME_HOME="$HOME/.config/awesome"
```

#### Colors
- red `#e06c75`
- green `#98c379`
- blue `#61afef`
- yellow `#e5c07b`
- purple `#c678dd`
- cyan `#56b6c2`
- text `#abb2bf`
- comments `#5c6370`
- background `#282c34`
- background dark `#21252b`
- background selected `#4d78cc`
- text selected `#ffffff`
