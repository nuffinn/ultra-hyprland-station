-- Hyprland Lua config (ported from hyprland.conf, 2026-10-16).
-- Wiki: https://wiki.hypr.land/Configuring/
-- API stubs for editor autocompletion: /usr/share/hypr/stubs/hl.meta.lua
--
-- Hyprland prefers hyprland.lua over hyprland.conf when both exist.
-- The old hyprland.conf is kept untouched as a fallback until this file is proven.


------------------
---- MONITORS ----
------------------

-- Monitor configuration managed by nwg-displays (writes monitors.lua).
require("monitors")


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "~/.config/rofi/launchers/type-7/launcher.sh"
local powermenu   = "~/.config/rofi/powermenu/type-1/powermenu.sh"


-------------------
---- AUTOSTART ----
-------------------

-- "hyprland.start" fires once at startup, not on config reload (was: exec-once).
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("tmux attach-session")
    hl.exec_cmd("quickshell -c notifications")        -- notifications + Super+N panel (was: swaync)
    hl.exec_cmd("~/.config/hypr/dota-altswap.sh")     -- un-swap Alt/Win while Dota 2 is focused (ping wheel)
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("HYPRCURSOR_SIZE", "24")

-- Scaling environment variables
hl.env("GDK_SCALE", "1.5")
hl.env("XCURSOR_SIZE", "36")   -- the .conf set 24 first, then 36; the last value won

-- Qt Wayland scaling fix
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_SCALE_FACTOR_ROUNDING_POLICY", "PassThrough")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Input method environment variables
hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("GLFW_IM_MODULE", "ibus")


-----------------------
----- PERMISSIONS -----
-----------------------

-- Permission changes require a Hyprland restart and are not applied on-the-fly.
-- hl.config({ ecosystem = { enforce_permissions = true } })
-- hl.permission({ regex = "/usr/(bin|local/bin)/grim", permission = "screencopy", mode = "allow" })


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 6,

        border_size = 2,

        col = {
            active_border   = "rgba(ffff99ff)",
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- See https://wiki.hypr.land/Configuring/extra/tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 0,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled    = true,
            size       = 8,
            passes     = 3,

            vibrancy   = 0.3,
            brightness = 1.0,
            contrast   = 1.0,
            noise      = 0.0117,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background
    },

    -- XWayland scaling
    xwayland = {
        force_zero_scaling = true,
    },
})

-- Curves and animations, see https://wiki.hypr.land/Configuring/core/animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1} } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

-- "Smart gaps" / "No gaps when only"
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
hl.window_rule({
    name  = "no-gaps-wtv1",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding    = 0,
})
hl.window_rule({
    name  = "no-gaps-f1",
    match = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding    = 0,
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_rules   = "",
        kb_options = "ctrl:swapcaps,altwin:swap_lalt_lwin",   -- must match NORMAL in dota-altswap.sh
        repeat_rate  = 30,
        repeat_delay = 300,

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Per-device config, see https://wiki.hypr.land/Configuring/core/devices/
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- TrackPoint: flat accel (no jumps); fine control from libinput multiplier (0.6)
hl.device({
    name          = "tpps/2-elan-trackpoint",
    accel_profile = "flat",
    sensitivity   = 0.25,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + Q",   hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C",   hl.dsp.window.close())
hl.bind(mainMod .. " + E",   hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V",   hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R",   hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P",   hl.dsp.window.pseudo())            -- dwindle
hl.bind(mainMod .. " + Tab", hl.dsp.layout("togglesplit"))      -- dwindle

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Custom
-- Hyprland-only fullscreen; client (e.g. Chrome) keeps its UI
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen_state({ internal = 2, client = 0 }))
hl.bind(mainMod .. " + t", hl.dsp.exec_cmd("hyprshot -m output --clipboard-only"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(powermenu))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("~/.config/hypr/toggle-transparency.sh"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("~/.config/hypr/toggle-kitty-blur.sh"))

-- Input method switching
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("fcitx5-remote -t"))

-- Notification centre (Quickshell global shortcut; was: swaync-client -t -sw)
hl.bind(mainMod .. " + N", hl.dsp.global("quickshell:notifcenter"))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Screenshot with hyprshot
hl.bind(mainMod .. " + equal",         hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.exec_cmd("hyprshot -m output --clipboard-only"))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Resize windows with mainMod + SHIFT + hjkl
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.resize({ x = -100, y = 0,    relative = true }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.resize({ x = 100,  y = 0,    relative = true }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.resize({ x = 0,    y = -100, relative = true }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.resize({ x = 0,    y = 100,  relative = true }))

-- Move windows
hl.bind(mainMod .. " + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.window.move({ direction = "down" }))

-- Laptop multimedia keys for volume and LCD brightness (notify-send with replacement; bypasses DND)
-- Long-bracket strings so the shell quoting inside is passed through untouched.
local volNotify = [[vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}') && notify-send -t 1500 -u low -i %s -h int:value:$vol -h string:x-canonical-private-synchronous:volume -h int:SWAYNC_BYPASS_DND:1 "Volume" "${vol}%%"]]
local briNotify = [[bri=$(brightnessctl -m | cut -d, -f4 | tr -d '%') && notify-send -t 1500 -u low -i display-brightness-symbolic -h int:value:$bri -h string:x-canonical-private-synchronous:brightness -h int:SWAYNC_BYPASS_DND:1 "Brightness" "${bri}%"]]

hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1.3 @DEFAULT_AUDIO_SINK@ 5%+ && " .. volNotify:format("audio-volume-high")),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && " .. volNotify:format("audio-volume-low")),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd([[wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && (wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && notify-send -t 1500 -u low -i audio-volume-muted -h string:x-canonical-private-synchronous:volume -h int:SWAYNC_BYPASS_DND:1 "Volume" "Muted" || ]] .. volNotify:format("audio-volume-high") .. ")"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd([[wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && (wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED && notify-send -t 1500 -u low -i microphone-sensitivity-muted -h string:x-canonical-private-synchronous:microphone -h int:SWAYNC_BYPASS_DND:1 "Microphone" "Muted" || notify-send -t 1500 -u low -i microphone-sensitivity-high -h string:x-canonical-private-synchronous:microphone -h int:SWAYNC_BYPASS_DND:1 "Microphone" "Unmuted")]]),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+ && " .. briNotify),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%- && " .. briNotify),
    { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Ignore maximize requests from apps.
hl.window_rule({
    name  = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "xwayland-drag-fix",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Picture-in-Picture windows
hl.window_rule({
    name  = "pip-no-border",
    match = { title = "^(Picture in picture)$" },
    border_size = 0,
})

-- Chrome: Hyprland fullscreen (Super+F) should not trigger Chrome's own fullscreen UI.
-- Hyprland still fills the screen with the window but does not report the state to the client.
-- Matches both the native Wayland class (google-chrome) and the XWayland one (Google-chrome).
hl.window_rule({
    name  = "chrome-no-sync-fullscreen",
    match = { class = "^([Gg]oogle-chrome)$" },
    sync_fullscreen = false,
})

-- Notification popups (Quickshell): all motion is done in QML, so Hyprland must not add its own fade or slide.
hl.layer_rule({
    name  = "notif-popups-no-anim",
    match = { namespace = "^notif-popups$" },
    no_anim = true,
})
hl.layer_rule({
    name  = "notif-workspace-no-anim",
    match = { namespace = "^notif-workspace$" },
    no_anim = true,
})
