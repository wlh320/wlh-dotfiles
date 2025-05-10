vim.g.rime_enabled = true

local rime_on_attach = function(client, _)
  local toggle_rime = function()
    client.request('workspace/executeCommand',
      { command = "rime-ls.toggle-rime" },
      function(_, result, ctx, _)
        if ctx.client_id == client.id then
          vim.g.rime_enabled = result
        end
      end
    )
  end
  -- keymaps for executing command
  vim.keymap.set('n', '<leader>rr', toggle_rime, { desc = 'Toggle [R]ime' })
  vim.keymap.set('i', '<C-x>', toggle_rime, { desc = 'Toggle Rime' })
  vim.keymap.set('n', '<leader>rs',
    function() vim.lsp.buf.execute_command({ command = "rime-ls.sync-user-data" }) end,
    { desc = '[R]ime [S]ync' })

  -- set trigger for different filetypes
  local set_rime_trigger = function(trigger)
    local clients = vim.lsp.get_clients({
      bufnr = vim.api.nvim_get_current_buf(),
      name = 'rime_ls',
    })
    for _, client in ipairs(clients) do
      local settings = { trigger_characters = trigger }
      client.config.settings = settings
      client.notify("workspace/didChangeConfiguration", { settings = settings })
    end
  end
  local filetype = vim.bo.filetype
  if filetype == "text"
    or filetype == "markdown"
    or filetype == "tex"
    or filetype == "typst"
  then
    set_rime_trigger({})
  else
    set_rime_trigger({">"})
  end
end

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

return {
  name = "rime_ls",
  -- cmd = { '/home/wlh/coding/rime-ls/target/debug/rime_ls' },
  -- cmd = { '/home/wlh/coding/rime-ls/target/release/rime_ls' },
  cmd = vim.lsp.rpc.connect('127.0.0.1', 9257),

  init_options = {
    enabled = vim.g.rime_enabled,
    shared_data_dir = "/usr/share/rime-data",
    user_data_dir = "~/.local/share/rime-ls",
    log_dir = "/tmp",
    max_candidates = 9,
    paging_characters = {",", "."},
    trigger_characters = {},
    schema_trigger_character = "&",
    max_tokens = 0,
    always_incomplete = false,
    preselect_first = false,
    show_filter_text_in_label = false,
    long_filter_text = true,
  },
  on_attach = rime_on_attach,
  capabilities = capabilities,
}
-- vim: ts=2 sts=2 sw=2 et
