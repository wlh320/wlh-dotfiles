local M = {}

function M.setup_rime()
  -- global status
  vim.g.rime_enabled = false

  -- update lualine
  local function rime_status()
    if vim.g.rime_enabled then
      return 'ㄓ'
    else
      return ''
    end
  end

  require('lualine').setup({
    sections = {
      lualine_x = { rime_status, 'encoding', 'fileformat', 'filetype' },
    }
  })

  -- add rime to lspconfig as a custom server
  local lspconfig = require('lspconfig')
  local configs = require('lspconfig.configs')
  if not configs.rime_ls then
    configs.rime_ls = {
      default_config = {
        name = "rime_ls",
        cmd = { 'rime_ls' },
        -- cmd = { '/home/wlh/coding/rime-ls/target/debug/rime_ls' },
        -- cmd = { '/home/wlh/coding/rime-ls/target/release/rime_ls' },
        -- cmd = vim.lsp.rpc.connect('127.0.0.1', 9257),
        filetypes = { '*' },
        single_file_support = true,
      },
      settings = {},
      docs = {
        description = [[
https://www.github.com/wlh320/rime-ls

A language server for librime
]],
      }
    }
  end

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
    vim.keymap.set('n', '<leader><space>', function() toggle_rime() end)
    vim.keymap.set('i', '<C-x>', function() toggle_rime() end)
    vim.keymap.set('n', '<leader>rs', function() vim.lsp.buf.execute_command({ command = "rime-ls.sync-user-data" }) end)
  end

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  lspconfig.rime_ls.setup {
    init_options = {
      enabled = vim.g.rime_enabled,
      shared_data_dir = "/usr/share/rime-data",
      user_data_dir = "~/.local/share/rime-ls",
      log_dir = "~/.local/share/rime-ls",
      max_candidates = 9,
      trigger_characters = {},
      schema_trigger_character = "&",
    },
    on_attach = rime_on_attach,
    capabilities = capabilities,
  }
end

return M
