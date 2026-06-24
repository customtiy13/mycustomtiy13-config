-- ~/.config/hypr/hyprland.lua
-- Migrated from old hyprlang syntax to Hyprland 0.55+ Lua config.

----------------
-- BASIC / ENV --
----------------

hl.config({
  ecosystem = {
    no_update_news = true,
  },
})

hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Amber")
hl.env("HYPRCURSOR_SIZE", "34")
hl.env("XCURSOR_SIZE", "34")
hl.env("XCURSOR_THEME", "Bibata-Modern-Amber")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("GDK_SCALE", "1.5")

----------------
-- AUTOSTART   --
----------------

hl.on("hyprland.start", function()
  hl.exec_cmd("alacritty-dropdown")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

  hl.exec_cmd("fcitx5 -d")
  hl.exec_cmd("waybar")

  hl.exec_cmd("swaybg -i ~/Pictures/milky-way-starry-sky-night-mountains-lake-reflection-cold-5k-3840x2160-287.jpg -m fill")
end)

--------------
-- MONITORS --
--------------

hl.monitor({
  output = "HDMI-A-2",
  mode = "3840x2160",
  position = "0x0",
  scale = 1.5,
})

hl.monitor({
  output = "eDP-1",
  mode = "1920x1080",
  position = "2560x195",
  scale = 1,
})

-----------
-- INPUT --
-----------

hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "ctrl:nocaps",
    kb_rules = "",

    follow_mouse = 1,
    mouse_refocus = true,

    touchpad = {
      natural_scroll = true,
    },

    sensitivity = 0,
  },

  xwayland = {
    force_zero_scaling = true,
  },
})

----------------
-- LOOK / FEEL --
----------------

hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,

    col = {
      active_border = {
        colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
        angle = 45,
      },
      inactive_border = "rgba(595959aa)",
    },

    resize_on_border = true,
    layout = "master",
  },

  group = {
    groupbar = {
      height = 18,
      font_size = 18,

      col = {
        active = {
          colors = { "rgba(66f5c2e7)", "rgba(66F9E2AF)" },
          angle = 90,
        },
        inactive = {
          colors = { "rgba(664D4D5A)", "rgba(667A6EAA)" },
          angle = 45,
        },
      },
    },
  },

  decoration = {
    rounding = 10,

    blur = {
      enabled = false,
      size = 3,
      passes = 1,
    },

    shadow = {
      enabled = false,
      range = 4,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },
  },

  animations = {
    enabled = true,
  },

  master = {
    mfact = 0.58,
    new_status = "slave",
    smart_resizing = true,
    drop_at_cursor = true,
  },

  binds = {
    workspace_back_and_forth = false,
    allow_workspace_cycles = true,
  },

  scrolling = {
    fullscreen_on_one_column = true,
    column_width = 0.5,
    focus_fit_method = 1,
    follow_focus = true,
    follow_min_visible = 0.4,
    explicit_column_widths = "0.333, 0.5, 0.667, 1.0",
    wrap_focus = true,
    wrap_swapcol = true,
    direction = "right",
  },
})

----------------
-- ANIMATIONS  --
----------------

hl.curve("myBezier", {
  type = "bezier",
  points = {
    { 0.05, 0.9 },
    { 0.1, 1.05 },
  },
})

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

------------
-- DEVICE --
------------

hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})

----------------
-- WINDOW RULES --
----------------

hl.window_rule({
  name = "dropdown-alacritty",
  match = {
    title = "^(dropdown-alacritty)$",
  },
  float = true,
  size = { "monitor_w*0.6", "monitor_h*0.5" },
  move = { "monitor_w*0.2", "monitor_h*0.05" },
  opacity = "1.0 override 0.5 override 0.8 override",
  workspace = "special:dropdown-alacritty",
})

hl.window_rule({
  name = "multimedia-tools",
  match = {
    class = "^(org.pulseaudio.pavucontrol|blueman-manager|com.gabm.satty)$",
  },
  float = true,
  size = { "monitor_w*0.5", "monitor_h*0.5" },
  center = true,
  opacity = "1.0 override 0.5 override 0.8 override",
})

hl.window_rule({
  name = "apps",
  match = {
    class = "^(librewolf|zen|obsidian|org.pwmt.zathura)$",
  },
  opacity = "0.92 override 0.82 override 1.0 override",
})

hl.window_rule({
  name = "wechat-media",
  match = {
    class = "^(wechat)$",
    title = "^(Photos and Videos)$",
  },
  float = true,
  size = { "monitor_w*0.5", "monitor_h*0.5" },
  center = true,
  opacity = "1.0 override 0.5 override 0.8 override",
})

hl.window_rule({
  name = "fullscreen-no-opacity",
  match = {
    fullscreen = true,
  },
  opacity = "1.0 override 1.0 override 1.0 override",
  border_size = 4,
})

hl.window_rule({
  name = "fullscreen-border",
  match = {
    fullscreen = true,
  },
  border_size = 4,
})

hl.window_rule({
  name = "browser_scrolling_width",
  match = {
    class = "^(librewolf|zen)$",
  },
  scrolling_width = 0.8,
})

hl.window_rule({
  name = "obsidian_scrolling_width",
  match = {
    class = "^(obsidian)$",
  },
  scrolling_width = 0.8,
})

hl.window_rule({
  name = "pdf-scrolling-width",
  match = {
    class = "^(org.pwmt.zathura)$",
  },
  scrolling_width = 0.8,
})

hl.window_rule({
  name = "suppress-maximize-events",
  match = {
    class = ".*",
  },
  suppress_event = "maximize",
})

hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

------------
-- GESTURE --
------------

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

hl.gesture({
  fingers = 3,
  direction = "down",
  mods = "ALT",
  action = "close",
})

-------------
-- KEYBINDS --
-------------

local mainMod = "ALT"
local super = "SUPER"

-- Move current workspace to another monitor
hl.bind(super .. " + SHIFT + h", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(super .. " + SHIFT + l", hl.dsp.workspace.move({ monitor = "r" }))

-- Master layout orientation
hl.bind(super .. " + LEFT", hl.dsp.layout("orientationleft"))
hl.bind(super .. " + RIGHT", hl.dsp.layout("orientationright"))

-- Basic app/window binds
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("fuzzel"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- fullscreen, 1 usually means maximized in old syntax
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(super .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Groups
hl.bind(mainMod .. " + G", hl.dsp.group.toggle({}))
hl.bind(mainMod .. " + f", hl.dsp.group.next({}))
-- hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.move({ out_of_group = true }))

-- Apps
hl.bind(super .. " + SHIFT + M", hl.dsp.exec_cmd("netease-cloud-music-gtk4"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("librewolf"))
hl.bind(super .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + CTRL + E", hl.dsp.exec_cmd("proxychains4 -q fractal"))
hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd("obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime"))

-- Screenshot
hl.bind(mainMod .. " + SHIFT + q", hl.dsp.exec_cmd('grim -g "`slurp`" - | satty -f -'))

-- Special workspace dropdown
hl.bind(mainMod .. " + minus", hl.dsp.workspace.toggle_special("dropdown-alacritty"))
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "special:dropdown-alacritty" }))

-- Focus movement
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))


hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Main workspaces 1-10
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Super workspaces
local super_workspaces = {
  Q = 60,
  F = 61,
  W = 62,
  Z = 63,
  E = 64,
  D = 65,
  O = 66,
  B = 67,
  T = 69,
  M = 70,
  N = 71,
  S = 72,
  P = 80,
  V = 81,
}

for key, ws in pairs(super_workspaces) do
  hl.bind(super .. " + " .. key, hl.dsp.focus({ workspace = ws }))
end

hl.workspace_rule({ workspace = "61", layout = "scrolling" }) -- browser scorlling
hl.workspace_rule({ workspace = "62", layout = "scrolling" }) -- browser scorlling
hl.workspace_rule({ workspace = "67", layout = "scrolling" }) -- book scorlling
hl.workspace_rule({ workspace = "10", layout = "scrolling" }) -- temp scorlling

-- Additional Super + 1..9 => 11..19
for i = 1, 9 do
  hl.bind(super .. " + " .. i, hl.dsp.focus({ workspace = i + 10 }))
end

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Resize active window
hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.resize({ x = -160, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.resize({ x = 160, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.resize({ x = 0, y = -160, relative = true }))
hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.resize({ x = 0, y = 160, relative = true }))

-- Mouse move/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Move windows
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "d" }))

----------------
-- SUBMAPS     --
----------------

-- For Steam: disable Hyprland binds temporarily with ALT+F12.
hl.bind("ALT + F12", hl.dsp.submap("disablebinds"))

hl.define_submap("disablebinds", function()
  hl.bind("F12", hl.dsp.submap("reset"))
end)
