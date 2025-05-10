local M = {
  base46 = {
    theme = "everforest", -- default theme
    transparency = true,
    hl_override = {
      CursorLine = {
        bg = "one_bg",
      }
    }
  },
  ui = {
    cmp = {
      icons_left = true,
      style = "atom_colored",
    },
    statusline = {
      theme = "default",
      separator_style = "round",
      order = { "mode", "file", "git", "%=", "diagnostics", "rime", "info", "cursor" },
      modules = {
        info = " %{&filetype} | %l:%c ",
        rime = function()
          if vim.g.rime_enabled then
            return ' ㄓ |'
          else
            return ''
          end
        end
      }
    },
  }
}
return M
-- vim: ts=2 sts=2 sw=2 et
