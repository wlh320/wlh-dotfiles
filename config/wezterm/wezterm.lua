local wezterm = require "wezterm"
local config = wezterm.config_builder()

-- window
config.initial_rows = 25
config.initial_cols = 100
config.enable_scroll_bar = true
config.scrollback_lines = 5000
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.window_background_opacity = 0.95
config.text_background_opacity = 0.95

config.use_fancy_tab_bar = false
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- config.integrated_title_button_alignment = "Left"
-- config.integrated_title_buttons = { 'Close', 'Maximize', 'Hide' }

-- font
config.font = wezterm.font("JetBrains Mono NF", { weight = "Regular" })
config.font_size = 14.0

-- color
config.color_scheme = "Catppuccin Mocha"

-- status
wezterm.on('update-right-status', function(window, _)
  local date = wezterm.strftime '%m/%d %a %H:%M:%S'

  -- Make it italic and underlined
  window:set_right_status(wezterm.format {
    { Attribute = { Underline = 'Single' } },
    { Attribute = { Italic = true } },
    { Text = date },
  })
end)

return config
