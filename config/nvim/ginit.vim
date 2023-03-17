lua << EOF

-- config neovide
if vim.fn.exists("g:neovide") == 1 then
  vim.g.neovide_transparency = 0.98
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.opt.guifont = { "JetBrains Mono", ":h12" }
end

-- config fvim
if vim.fn.exists('g:fvim_loaded') == 1 then
  vim.opt.guifont = { "JetBrains Mono", ":h15" } -- with embedded NF font
  vim.keymap.set('n', '<C-ScrollWheelUp>', '<cmd>set guifont=+<cr>', { silent = true })
  vim.keymap.set('n', '<C-ScrollWheelDown>', '<cmd>set guifont=-<cr>', { silent = true })
  vim.keymap.set('n', '<A-CR>', '<cmd>FVimToggleFullScreen<cr>', { silent = true })
  vim.cmd [[ FVimCursorSmoothMove v:true ]]
  vim.cmd [[ FVimCursorSmoothBlink v:true ]]
  vim.cmd [[ FVimBackgroundComposition 'blur' ]]
  vim.cmd [[ FVimBackgroundOpacity 0.9 ]]
  vim.cmd [[ FVimBackgroundAltOpacity 0.9 ]]
  vim.cmd [[ FVimCustomTitleBar v:true ]]
  vim.cmd [[ FVimUIPopupMenu v:true ]]
end

EOF
