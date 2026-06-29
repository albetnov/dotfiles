-- Hyprland Lua Config
-- Migrated from hyprland.conf
-- See: https://wiki.hypr.land/Configuring/Start/

local colors      = require("lua.colors")

-- ──────────────────────────────────────────────
-- PROGRAM VARIABLES
-- ──────────────────────────────────────────────
local terminal    = "ghostty"
local fileManager = "dolphin"
local browser     = "helium-browser"
local ss_dir      = os.getenv("HOME") .. "/Pictures/Screenshots"

local function ipc(cmd)
  return hl.dsp.exec_cmd("qs -c noctalia-shell ipc call " .. cmd)
end

-- ──────────────────────────────────────────────
-- MONITORS
-- ──────────────────────────────────────────────
hl.monitor({
  output   = "HDMI-A-1",
  mode     = "1920x1080@60Hz",
  position = "0x0",
  scale    = 1,
})

hl.monitor({
  output   = "eDP-1",
  mode     = "1920x1080@60Hz",
  position = "1920x0",
  scale    = 1,
})

-- ──────────────────────────────────────────────
-- ENVIRONMENT VARIABLES
-- ──────────────────────────────────────────────
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("SSH_AUTH_SOCK", "$XDG_RUNTIME_DIR/ssh-agent.socket")
hl.env("GRIMBLAST_EDITOR", "satty -f")
hl.env("HYPRCURSOR_THEME", "Catppuccin Macchiato Blue")

-- ──────────────────────────────────────────────
-- PERMISSIONS (disabled)
-- ──────────────────────────────────────────────
-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-- ──────────────────────────────────────────────
-- CONFIG: LOOK AND FEEL
-- ──────────────────────────────────────────────

hl.config({
  general = {
    gaps_in          = 5,
    gaps_out         = 10,
    border_size      = 2,
    col              = {
      active_border   = colors.general_col.active_border,
      inactive_border = colors.general_col.inactive_border,
    },
    resize_on_border = false,
    allow_tearing    = false,
    layout           = "dwindle",
  },

  group = {
    groupbar = {
      enabled       = true,
      font_size     = 12,
      height        = 22,
      render_titles = true,
      col           = {
        active          = colors.groupbar_col.active,
        inactive        = colors.groupbar_col.inactive,
        locked_active   = colors.groupbar_col.locked_active,
        locked_inactive = colors.groupbar_col.locked_inactive,
      },
    },
    col = {
      border_active          = colors.group_col.border_active,
      border_inactive        = colors.group_col.border_inactive,
      border_locked_active   = colors.group_col.border_locked_active,
      border_locked_inactive = colors.group_col.border_locked_inactive,
    },
  },

  decoration = {
    rounding           = 12,
    rounding_power     = 2,

    active_opacity     = 1.0,
    inactive_opacity   = 0.96,
    fullscreen_opacity = 1.0,

    shadow             = {
      enabled      = true,
      range        = 20,
      render_power = 4,
      color        = "rgba(00000088)",
      offset       = "0 8",
    },

    blur               = {
      enabled           = true,
      size              = 6,
      passes            = 3,
      vibrancy          = 0.17,
      noise             = 0.01,
      new_optimizations = true,
      xray              = false,
    },
  },

  dwindle = {
    preserve_split = true,
    smart_split    = false,
  },

  master = {
    new_status = "master",
  },

  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo   = false,
  },
})

-- ──────────────────────────────────────────────
-- ANIMATIONS
-- ──────────────────────────────────────────────

hl.curve("overshoot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("snap", { type = "bezier", points = { { 0.1, 1 }, { 0.1, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 3.5, bezier = "snap" })
hl.animation({ leaf = "windows", enabled = true, speed = 3.8, bezier = "snap" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.2, bezier = "overshoot", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.2, bezier = "quick", style = "popin 80%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2.0, bezier = "quick" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.0, bezier = "quick" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.5, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.0, bezier = "snap" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3.0, bezier = "snap", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.0, bezier = "quick", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.8, bezier = "snap", style = "slidefadevert 15%" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 2.8, bezier = "snap", style = "slidefadevert 15%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.0, bezier = "snap", style = "slidefadevert 15%" })

-- ──────────────────────────────────────────────
-- INPUT
-- ──────────────────────────────────────────────

hl.config({
  input = {
    kb_layout    = "us",
    kb_variant   = "",
    kb_model     = "",
    kb_options   = "",
    kb_rules     = "",

    follow_mouse = 1,
    sensitivity  = 0,

    touchpad     = {
      natural_scroll = true,
    },
  },
})

hl.gesture({
  fingers   = 3,
  direction = "horizontal",
  action    = "workspace",
})

hl.device({
  name        = "epic-mouse-v1",
  sensitivity = -0.5,
})

-- ──────────────────────────────────────────────
-- KEYBINDINGS
-- ──────────────────────────────────────────────

-- ── Apps & Launcher ───────────────────────────
hl.bind("SUPER + SPACE", ipc("launcher toggle"))
hl.bind("SUPER + Return", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager))
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser))

-- ── Noctalia Shell ────────────────────────────
hl.bind("SUPER + S", ipc("controlCenter toggle"))
hl.bind("SUPER + comma", ipc("settings toggle"))
hl.bind("SUPER + N", ipc("notifications toggleHistory"))
hl.bind("SUPER + SHIFT + N", ipc("notifications toggleDND"))
hl.bind("SUPER + W", ipc("desktopWidgets toggle"))
hl.bind("SUPER + D", ipc("dock toggle"))
hl.bind("SUPER + Escape", ipc("sessionMenu toggle"))
hl.bind("SUPER + L", ipc("lockScreen lock"))
hl.bind("SUPER + SHIFT + D", ipc("darkMode toggle"))
hl.bind("SUPER + SHIFT + I", ipc("idleInhibitor toggle"))
hl.bind("SUPER + SHIFT + W", ipc("wallpaper random"))

-- ── Launcher Modes ────────────────────────────
hl.bind("SUPER + V", ipc("launcher clipboard"))
hl.bind("SUPER + period", ipc("launcher emoji"))
hl.bind("SUPER + Tab", ipc("launcher windows"))

-- ── Window Management ─────────────────────────
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + SHIFT + SPACE", function()
  hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
  hl.dispatch(hl.dsp.window.center())
end)
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + backslash", hl.dsp.layout("swapsplit"))

-- ── Window Groups ─────────────────────────────
hl.bind("SUPER + T", hl.dsp.group.toggle())
hl.bind("SUPER + bracketright", hl.dsp.group.next())
hl.bind("SUPER + bracketleft", hl.dsp.group.prev())
hl.bind("SUPER + SHIFT + T", hl.dsp.window.move({ into_group = "left" }))
hl.bind("SUPER + CTRL + T", hl.dsp.window.move({ out_of_group = true }))

-- ── Special Workspace (minimize) ─────────────
hl.bind("SUPER + M", hl.dsp.window.move({ workspace = "special:minimized" }))
hl.bind("SUPER + SHIFT + M", hl.dsp.workspace.toggle_special("minimized"))
hl.bind("SUPER + CTRL + M", hl.dsp.window.move({ workspace = "e+0" }))

-- ── Focus ─────────────────────────────────────
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))

-- ── Move Windows ──────────────────────────────
-- ponytail: these use hyprctl dispatch — hl.dsp.window.move signature for
-- directional swap is unclear from stubs. Switch to native if confirmed.
hl.bind("SUPER + SHIFT + H", hl.dsp.exec_cmd("hyprctl dispatch movewindow l"))
hl.bind("SUPER + SHIFT + J", hl.dsp.exec_cmd("hyprctl dispatch movewindow d"))
hl.bind("SUPER + SHIFT + K", hl.dsp.exec_cmd("hyprctl dispatch movewindow u"))
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("hyprctl dispatch movewindow r"))

-- ── Resize ────────────────────────────────────
hl.bind("SUPER + CTRL + H", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -40 0"))
hl.bind("SUPER + CTRL + J", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 40"))
hl.bind("SUPER + CTRL + K", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -40"))
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 40 0"))

-- ── Workspaces ────────────────────────────────
for i = 1, 9 do
  hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ── Media Keys ────────────────────────────────
hl.bind("XF86AudioRaiseVolume", ipc("volume increase"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", ipc("volume decrease"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", ipc("volume muteOutput"), { locked = true })
hl.bind("XF86AudioMicMute", ipc("volume muteInput"), { locked = true })
hl.bind("XF86MonBrightnessUp", ipc("brightness increase"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", ipc("brightness decrease"), { repeating = true, locked = true })
hl.bind("XF86AudioPlay", ipc("media playPause"), { locked = true })
hl.bind("XF86AudioNext", ipc("media next"), { locked = true })
hl.bind("XF86AudioPrev", ipc("media previous"), { locked = true })

-- ── Poweroff ──────────────────────────────────
hl.bind("XF86PowerOff", function()
  hl.exec_cmd('zenity --question --text="Shutting down in 10 seconds..." --timeout=10 && shutdown now')
end)

-- ── Screenshots ───────────────────────────────
local function grim(mode, to_file)
  return function()
    local cmd = "grimblast --notify --freeze " .. mode
    if to_file then cmd = cmd .. " " .. ss_dir .. "/" .. os.date("%Y%m%d_%H%M%S") .. ".png" end
    hl.exec_cmd(cmd)
  end
end

-- Save to file
hl.bind("Print", grim("save screen", true))
hl.bind("SUPER + Print", grim("save area", true))
hl.bind("SUPER + ALT + Print", grim("save active", true))
hl.bind("SUPER + CTRL + Print", grim("save output", true))

-- Copy to clipboard only
hl.bind("SHIFT + Print", grim("copy screen", false))
hl.bind("SUPER + SHIFT + Print", grim("copy area", false))
hl.bind("SUPER + SHIFT + ALT + Print", grim("copy active", false))

-- Save + copy (area)
hl.bind("CTRL + Print", grim("copysave area", true))

-- Edit (opens in $GRIMBLAST_EDITOR)
hl.bind("SUPER + CTRL + ALT + Print", grim("edit area", false))

-- ── Noctalia Restart ──────────────────────────
hl.bind("SUPER + SHIFT + R", function()
  hl.exec_cmd("pkill quickshell; nohup qs -c noctalia-shell > /dev/null 2>&1 &")
end)

-- ──────────────────────────────────────────────
-- WINDOW RULES
-- ──────────────────────────────────────────────

-- Suppress maximize events from all apps
hl.window_rule({
  name           = "suppress-maximize-events",
  match          = { class = ".*" },
  suppress_event = "maximize",
})

-- Fix XWayland drag issues
hl.window_rule({
  name     = "fix-xwayland-drags",
  match    = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },
  no_focus = true,
})

-- Hyprland-run popup
hl.window_rule({
  name  = "move-hyprland-run",
  match = { class = "hyprland-run" },
  move  = "20 monitor_h-120",
  float = true,
})

-- XWayland Video Bridge
hl.window_rule({
  name             = "xwayland-video-bridge-fixes",
  match            = { class = "xwaylandvideobridge" },
  no_initial_focus = true,
  no_focus         = true,
  no_anim          = true,
  no_blur          = true,
  max_size         = "1 1",
  opacity          = 0.0,
})

-- Center all floating windows except Zoom
hl.window_rule({
  name   = "center-floating",
  match  = {
    float = true,
    -- Match any class that does NOT contain "zoom" or "Zoom"
    class = "^(?!.*(zoom|Zoom)).*$",
  },
  center = true,
})

-- ── Zoom: global rules ────────────────────────
hl.window_rule({
  name         = "zoom-global",
  match        = { class = "^(zoom)$" },
  idle_inhibit = "always",
  no_blur      = true,
})

-- ── Zoom: float all secondary/popup windows ───
hl.window_rule({
  name   = "zoom-floats",
  match  = {
    class         = "^(zoom)$",
    initial_title =
    "^(zoom|Settings|Chat|menu window|confirm window|Breakout rooms - In Progress|ZOOM|annotate_toolbar)$",
  },
  float  = true,
  center = true,
})

-- ── Zoom: stay focused for disappearing popups
hl.window_rule({
  name         = "zoom-stay-focused",
  match        = {
    class = "^(zoom)$",
    title = "^(menu window|confirm window)$",
  },
  stay_focused = true,
})

-- ── Zoom: suppress initial focus ──────────────
hl.window_rule({
  name             = "zoom-no-focus",
  match            = {
    class         = "^(zoom)$",
    initial_title = "^(zoom)$",
  },
  no_initial_focus = true,
})

-- ── Android Studio: tame tooltips ─────────────
hl.window_rule({
  name             = "please-behave-android-studio",
  match            = {
    initial_class = "^jetbrains-studio$",
    initial_title = "^win[0-9]+$",
  },
  no_initial_focus = true,
  float            = true,
})

-- ──────────────────────────────────────────────
-- LAYER RULES
-- ──────────────────────────────────────────────

hl.layer_rule({
  name         = "noctalia",
  match        = { namespace = "noctalia-background-.*$" },
  ignore_alpha = 0.5,
  blur         = true,
  blur_popups  = true,
})

-- ──────────────────────────────────────────────
-- MONITOR HOTPLUG (replaces hyprland-switcher.sh)
-- ──────────────────────────────────────────────

local function assign_workspaces()
  local monitors = hl.get_monitors()
  local has_hdmi = false
  for _, m in ipairs(monitors) do
    if m.name == "HDMI-A-1" then
      has_hdmi = true
      break
    end
  end

  if has_hdmi then
    hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1", default = true })
    hl.workspace_rule({ workspace = "2", monitor = "eDP-1", default = true })
    hl.dispatch(hl.dsp.workspace.move({ workspace = 1, monitor = "HDMI-A-1" }))
    hl.dispatch(hl.dsp.workspace.move({ workspace = 2, monitor = "eDP-1" }))
  else
    hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })
    hl.dispatch(hl.dsp.workspace.move({ workspace = 1, monitor = "eDP-1" }))
  end

  hl.dispatch(hl.dsp.focus({ workspace = 1 }))
end

hl.on("monitor.added", assign_workspaces)
hl.on("monitor.removed", assign_workspaces)

-- ──────────────────────────────────────────────
-- STARTUP EVENTS
-- ──────────────────────────────────────────────

hl.on("hyprland.start", function()
  -- Shell / UI
  hl.exec_cmd("qs -c noctalia-shell")
  hl.exec_cmd("hypridle")

  -- Wayland environment
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

  -- KDE integration
  hl.exec_cmd("/usr/lib/pam_kwallet_init")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")

  -- KDE cache rebuild (previously kde-cache.sh)
  os.execute("rm -f ~/.cache/ksycoca6_*")
  os.execute("XDG_MENU_PREFIX=plasma- kbuildsycoca6 --noincremental")

  -- Initial workspace assignment
  assign_workspaces()
end)
