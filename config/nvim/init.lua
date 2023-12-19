-- wlh's init.lua configs
-- ver 2023-12-19
-- heavily using nvim-lua/kickstart.nvim for reference

-- [[ Basic Settings ]]

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set color
vim.o.termguicolors = true
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- my custom setting
vim.opt.cmdheight = 1
vim.opt.spelllang = "en,cjk"
vim.opt.relativenumber = true
vim.wo.cursorline = true
vim.wo.wrap = false
vim.wo.colorcolumn = "100" -- column ruler
-- my default tabwidth
local TABWIDTH = 4
vim.opt.tabstop = TABWIDTH
vim.opt.shiftwidth = TABWIDTH
vim.opt.expandtab = true

-- [[ Basic Keymaps ]]

-- Set <space> as the leader key
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for move lines in visual mode
vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv", { desc = 'move lines j' })
vim.keymap.set('v', 'K', ":m '<-2<cr>gv=gv", { desc = 'move lines k' })
vim.keymap.set('n', 'J', 'J^')

-- Remap for better paste-and-yank
vim.keymap.set('x', '<leader>p', '"_dP', { desc = '[P]aste without save current word' })
vim.keymap.set('n', '<leader>y', '"+y', { desc = '[Y]ank from system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+Y')

-- Remap for quick global replacement
vim.keymap.set('n', '<leader>s', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = 'Quick [S]witch'})

-- use Ctrl-hjkl to move between windows
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- keymap for toggle some plugins
vim.keymap.set('n', '<leader>t', '<cmd>exe v:count1 . "ToggleTerm"<cr>', { desc = '[t]erminal' })
vim.keymap.set('n', '<leader>T', '<cmd>exe v:count1 . "ToggleTerm direction=vertical"<cr>', { desc = '[T]erminal Vertical'})
vim.keymap.set('n', '<C-t>', '<cmd>exe v:count1 . "ToggleTerm direction=float"<cr>', { desc = '[t]erminal floating' })
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { desc = 'Toggle File [E]xplorer' })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Plugin Settings ]]

-- Copy from NvChad lazy_load function
local lazy_load = function(plugin)
  vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
    callback = function()
      local file = vim.fn.expand "%"
      local condition = file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= ""

      if condition then
        vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)
        -- dont defer for treesitter as it will show slow highlighting
        -- This deferring only happens only when we do "nvim filename"
        if plugin ~= "nvim-treesitter" then
          vim.schedule(function()
            require("lazy").load { plugins = plugin }
            if plugin == "nvim-lspconfig" then
              vim.cmd "silent! do FileType"
            end
          end)
        else
          require("lazy").load { plugins = plugin }
        end
      end
    end,
  })
end

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Config Catppuccin
local catppuccin = {
  'catppuccin/nvim',
  lazy = false,
  name = 'catppuccin',
  config = function()
    require('catppuccin').setup({
      flavour = 'mocha', -- latte, frappe, macchiato, mocha
      transparent_background = false,
      term_colors = true,
      custom_highlights = function(colors)
        return {
          IndentBlanklineContextChar = { fg = colors.overlay0 },
        }
      end
    })
    vim.cmd.colorscheme 'catppuccin'
  end
}

-- Config lualine
local lualine = {
  'nvim-lualine/lualine.nvim', -- Fancier statusline
  event = "VeryLazy",
  config = function()
    -- rime-ls status on lualine
    local function rime_status()
      if vim.g.rime_enabled then
        return 'ㄓ'
      else
        return ''
      end
    end

    require('lualine').setup {
      options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_x = { rime_status, 'encoding', 'fileformat', 'filetype' },
      }
    }
  end
}

-- Config indent_blankline
local indent_blankline = {
  'lukas-reineke/indent-blankline.nvim',
  init = function()
    lazy_load "indent-blankline.nvim"
  end,
  config = function()
    require('ibl').setup {
      indent = { char = '┊' },
    }
  end
}

-- Config gitsigns
local gitsigns = {
  'lewis6991/gitsigns.nvim',
  init = function()
    -- load gitsigns only when a git file is opened
    vim.api.nvim_create_autocmd({ "BufRead" }, {
      group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
      callback = function()
        vim.fn.system("git -C " .. vim.fn.expand "%:p:h" .. " rev-parse")
        if vim.v.shell_error == 0 then
          vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
          vim.schedule(function()
            require("lazy").load { plugins = { "gitsigns.nvim" } }
          end)
        end
      end,
    })
  end,
  config = function()
    require('gitsigns').setup {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    }
    -- keymap for previewing hunks
    vim.keymap.set('n', '<leader>gh', '<cmd>Gitsigns preview_hunk<cr>', { desc = '[G]itsigns preview [H]unks' })
    vim.keymap.set('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>', { desc = '[G]itsigns [R]eset hunk' })
    vim.keymap.set('n', '<leader>gp', '<cmd>Gitsigns prev_hunk<cr>', { desc = '[G]itsigns [P]revious hunk' })
    vim.keymap.set('n', '<leader>gn', '<cmd>Gitsigns next_hunk<cr>', { desc = '[G]itsigns [N]ext hunk' })
  end
}

-- Config barbar
local barbar = {
  'romgrk/barbar.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = "BufAdd",
  config = function()
    -- set sidebar offset
    require('barbar').setup {
      sidebar_filetypes = {
        NvimTree = { text = 'File Explorer' }
      }
    }
    -- move between buffers
    vim.keymap.set('n', '<S-h>', '<cmd>BufferPrevious<cr>', { desc = 'Previous Buffer'})
    vim.keymap.set('n', '<S-l>', '<cmd>BufferNext<cr>', { desc = 'Next Buffer' })
    vim.keymap.set('n', '<leader>bp', '<cmd>BufferPick<cr>', { desc = '[B]uffer [P]ick' })
    vim.keymap.set('n', '<leader>b1', '<cmd>BufferGoto 1<cr>', { desc = '[B]uffer 1'})
    vim.keymap.set('n', '<leader>b2', '<cmd>BufferGoto 2<cr>', { desc = '[B]uffer 2'})
    vim.keymap.set('n', '<leader>b3', '<cmd>BufferGoto 3<cr>', { desc = '[B]uffer 3'})
    vim.keymap.set('n', '<leader>b4', '<cmd>BufferGoto 4<cr>', { desc = '[B]uffer 4'})
    vim.keymap.set('n', '<leader>b5', '<cmd>BufferGoto 5<cr>', { desc = '[B]uffer 5'})
    -- close buffers
    vim.keymap.set('n', '<leader>bc', '<cmd>BufferClose<cr>', { desc = '[B]uffer [C]lose'})
    vim.keymap.set('n', '<leader>x', '<cmd>BufferClose<cr>', { desc = '[B]uffer [X]'})
    vim.keymap.set('n', '<leader>bd', '<cmd>BufferPickDelete<cr>', { desc = '[B]uffer [D]elete'})
  end
}

-- Config toggleterm
local toggleterm = {
  'akinsho/toggleterm.nvim',
  version = '*', -- Terminal
  cmd = { 'ToggleTerm' },
  config = function()
    require('toggleterm').setup({
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.3
        end
      end
    })
    -- set keymaps to easily move between buffers and terminal
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n><Cmd>ToggleTerm<CR>]], opts)
    end

    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end
}

-- Config nvim-tree
local nvimtree = {
  'nvim-tree/nvim-tree.lua',
  dependencies = 'nvim-tree/nvim-web-devicons',
  cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
  config = function()
    require('nvim-tree').setup({
      actions = {
        change_dir = {
          enable = true,
          global = true
        }
      },
      renderer = {
        indent_markers = {
          enable = true
        }
      }
    })
  end
}

-- Config whichkey
local whichkey = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")
    wk.register({
      b = { name = "Buffer" },
      d = { name = "Diagnostic" },
      g = { name = "Gitsigns" },
      w = { name = "Workspace" },
      r = { name = "Rime" },
      l = { name = "LaTeX" },
    }, { prefix = "<leader>" })
  end
}

-- Config treesitter
local treesitter = {
  'nvim-treesitter/nvim-treesitter',
  init = function()
    lazy_load "nvim-treesitter"
  end,
  dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = function()
    pcall(require('nvim-treesitter.install').update { with_sync = true })
  end,
  config = function()
    require('nvim-treesitter.configs').setup {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = { 'c', 'cpp', 'go', 'python', 'rust', 'vimdoc', 'lua', 'vim' },

      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<c-backspace>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']c'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']C'] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[c'] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[C'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    }
    -- Diagnostic keymaps
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, { desc = '[D]iagnostic [F]loat' })
    vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = '[D]iagnostic [Q]uickfix'})
  end
}

-- Config nvim-cmp
local cmp = {
  'hrsh7th/nvim-cmp',
  event = "InsertEnter",
  dependencies = {
    {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'saadparwaiz1/cmp_luasnip',
    },
    { -- Config luasnip
      'L3MON4D3/LuaSnip',
      dependencies = {
        'rafamadriz/friendly-snippets',
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
      },
    },
    { -- Config autopairs
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup {}
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        require('cmp').event:on(
          'confirm_done',
          cmp_autopairs.on_confirm_done()
        )
      end
    },
  },
  config = function()
    local cmp = require 'cmp'
    local compare = require 'cmp.config.compare'
    local luasnip = require 'luasnip'

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      sorting = {
        comparators = {
          compare.sort_text,
          compare.offset,
          compare.exact,
          compare.score,
          compare.recently_used,
          compare.kind,
          compare.length,
          compare.order,
        }
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<A-l>'] = cmp.mapping.complete(),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<Space>'] = cmp.mapping(function(fallback)
          local entry = cmp.get_selected_entry()
          if entry == nil then
            entry = cmp.core.view:get_first_entry()
          end
          if entry and entry.source.name == "nvim_lsp"
              and entry.source.source.client.name == "rime_ls" then
            cmp.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            })
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<CR>'] = cmp.mapping(function(fallback)
          local entry = cmp.get_selected_entry()
          if entry == nil then
            entry = cmp.core.view:get_first_entry()
          end
          if entry and entry.source.name == 'nvim_lsp'
            and entry.source.source.client.name == 'rime_ls' then
            cmp.abort()
          else
            if entry ~= nil then
              cmp.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true
              })
            else
              fallback()
            end
          end
        end, {'i', 's'}),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'nvim_lsp_signature_help' }
      },
    }
    -- forget current snippet after leaving insert mode
    local unlinkgrp = vim.api.nvim_create_augroup(
      'UnlinkSnippetOnModeChange',
      { clear = true }
    )
    vim.api.nvim_create_autocmd('ModeChanged', {
      group = unlinkgrp,
      pattern = { 's:n', 'i:*' },
      desc = 'Forget the current snippet when leaving the insert mode',
      callback = function(event)
        if luasnip.session
            and luasnip.session.current_nodes[event.buf]
            and not luasnip.session.jump_active
        then
          luasnip.unlink_current()
        end
      end,
    })
  end
}

-- Mason
local mason = {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
  config = true,
}

-- Config LSP
local lspconfig = {
  'neovim/nvim-lspconfig',
  init = function()
    lazy_load "nvim-lspconfig"
  end,
  dependencies = {
    -- Setup lsp installed in mason
    'williamboman/mason-lspconfig.nvim',
    -- Useful status updates for LSP
    { 'j-hui/fidget.nvim', config = true },
  },
  config = function()
    -- LSP settings.
    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(_, bufnr)
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

      nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
      nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

      -- See `:help K` for why this keymap
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Lesser used LSP functionality
      nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
      nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
      nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, '[W]orkspace [L]ist Folders')
    end

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    -- force utf-16
    capabilities.offsetEncoding = { 'utf-16' }

    -- Load mason_lspconfig
    local mason_lspconfig = require 'mason-lspconfig'
    mason_lspconfig.setup_handlers {
      function(server_name)
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
        }
      end,
      -- dedicated handler
      ["texlab"] = function()
        require('lspconfig').texlab.setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            texlab = {
              -- I prefer formatting bibtex file with latexindent
              bibtexFormatter = 'latexindent'
            }
          }
        }
      end
    }

    -- My rime-ls settings
    require('rime').setup_rime()
  end
}

-- Config conform.nvim
local conform = {
  'stevearc/conform.nvim',
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function() require("conform").format({ async = true, lsp_fallback = true }) end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        python = { "black" },
        tex = { "latexindent" },
        ["_"] = { "trim_whitespace" },
      },
    })
  end,
}

-- Config illuminate
local illuminate = {
  'RRethy/vim-illuminate',
  init = function()
    lazy_load "vim-illuminate"
  end,
  config = function()
    require("illuminate").configure({
      delay = 200,
      filetypes_denylist = {
        "NvimTree",
        "toggleterm",
        "TelescopePrompt",
      },
    })
  end,
  keys = {
    {
      "]r",
      function()
        require("illuminate").goto_next_reference(false)
      end,
      desc = "illuminate Next Reference",
    },
    {
      "[r",
      function()
        require("illuminate").goto_prev_reference(false)
      end,
      desc = "illuminate Prev Reference",
    },
  },
}

-- Config comment
local comment = {
    "numToStr/Comment.nvim",
    keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
    config = function()
      require("Comment").setup()
    end
}

-- Config telescope
local telescope = {
  'nvim-telescope/telescope.nvim',
  cmd = "Telescope",
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function() return vim.fn.executable 'make' == 1 end,
    },
  },
  init = function()
    -- Keymap for toggling telescope
    vim.keymap.set('n', '<C-p>', function()
      local builtin = require('telescope.builtin')
      vim.fn.system('git rev-parse --is-inside-work-tree')
      if vim.v.shell_error == 0 then builtin.git_files() else builtin.find_files() end
    end, { desc = 'Ctrl-P: search editable files' })
    vim.keymap.set('n', '<leader>?', "<cmd>Telescope oldfiles<cr>", { desc = 'Find recent files' })
    vim.keymap.set('n', '<leader>sb', function()
      local builtin = require('telescope.builtin')
      builtin.current_buffer_fuzzy_find(
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.themes').get_dropdown { previewer = false }
      )
    end, { desc = '[S]earch [B]uffer' })
    vim.keymap.set('n', '<leader>sf', "<cmd>Telescope find_files<cr>", { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh', "<cmd>Telescope help_tags<cr>", { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', "<cmd>Telescope grep_string<cr>", { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', "<cmd>Telescope live_grep<cr>", { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', "<cmd>Telescope diagnostics<cr>", { desc = '[S]earch [D]iagnostics' })

    -- LSP keymap
    vim.keymap.set('n', 'gr', "<cmd>Telescope lsp_references<cr>", { desc = '[G]oto [R]eferences' })
    vim.keymap.set('n', '<leader>ds', "<cmd>Telescope lsp_document_symbols<cr>", { desc = '[D]ocument [S]ymbols' })
    vim.keymap.set('n', '<leader>ws', "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = '[W]orkspace [S]ymbols' })
  end,
  config = function()
    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')
  end
}

-- Config vimtex
local vimtex = {
  'lervag/vimtex',
  lazy = false,
  config = function()
    vim.g.vimtex_compiler_engine = 'pdflatex'
    vim.g.vimtex_view_method = 'zathura'
    vim.g.maplocalleader = ' '
  end,
}

-- Config Lazy
local lazy_plugins = {
  -- Themes
  catppuccin,

  -- UI related
  lualine,
  indent_blankline,
  gitsigns,
  barbar,
  toggleterm,
  nvimtree,
  whichkey,

  -- Coding
  treesitter,
  cmp,
  mason,
  lspconfig,
  conform,
  illuminate,
  comment,
  { 'tpope/vim-sleuth', init = function() lazy_load "vim-sleuth" end },

  -- Language specific
  vimtex,

  -- Fuzzy Finder (files, lsp, etc)
  telescope,
}

local lazy_config = {
  defaults = { lazy = true },
}

require('lazy').setup(lazy_plugins, lazy_config)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
