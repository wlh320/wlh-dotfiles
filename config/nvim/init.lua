-- wlh's init.lua configs
-- ver 2025-01-02
-- heavily using nvim-lua/kickstart.nvim for reference

-- [[ Basic Settings ]]

-- Set highlight on search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Set color
vim.o.termguicolors = true
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- my custom setting
vim.opt.cmdheight = 1
vim.opt.spelllang = "en,cjk"
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
vim.keymap.set('n', '<leader>S', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = 'Quick [S]witch'})

-- use Ctrl-hjkl to move between windows
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- move between buffer
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = "Previous Buffer"})
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = "Next Buffer"})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Plugin Settings ]]

-- Install nvchad ui
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46_cache/"

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

-- Config indent_blankline
local indent_blankline = {
  'lukas-reineke/indent-blankline.nvim',
  event = "LazyFile",
  config = function()
    require('ibl').setup {
      indent = { char = '┊' },
      exclude = {
        filetypes = {
          "toggleterm",
        }
      }
    }
  end
}

-- Config gitsigns
local gitsigns = {
  'lewis6991/gitsigns.nvim',
  event = "LazyFile",
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
    local gs = require('gitsigns')
    vim.keymap.set("n", "]h", function() gs.nav_hunk("next") end, { desc = "Next Hunk" })
    vim.keymap.set("n", "[h", function() gs.nav_hunk("prev") end, { desc = "Prev Hunk" })
    vim.keymap.set("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Blame Line" })
    vim.keymap.set('n', '<leader>gh', '<cmd>Gitsigns preview_hunk<cr>', { desc = '[G]itsigns preview [H]unks' })
    vim.keymap.set('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>', { desc = '[G]itsigns [R]eset hunk' })
  end
}

-- Config neotree
local neotree = {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy",
  keys = {
    { "<leader>e", ":Neotree toggle float<CR>", silent = true, desc = "Float File Explorer" },
    { "<leader>E", ":Neotree toggle left<CR>", silent = true, desc = "Left File Explorer" },
  },
  config = function()
    require("neo-tree").setup({
      window = {
        position = "float",
        width = 35,
      },
      source_selector = {
        winbar = true,
      },
      event_handlers = {
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end
          end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end
          end,
        },
      },
    })
  end,
}

-- Config whichkey
local whichkey = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>d", group = "Diagnostic" },
      { "<leader>g", group = "Gitsigns" },
      { "<leader>l", group = "LaTeX" },
      { "<leader>r", group = "Rime" },
      { "<leader>w", group = "Workspace" },
    })
  end
}

-- Config treesitter
local treesitter = {
  'nvim-treesitter/nvim-treesitter',
  event = { "LazyFile", "VeryLazy" },
  dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  config = function()
    require('nvim-treesitter.configs').setup {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = { 'c', 'cpp', 'python', 'rust', 'vimdoc', 'vim', 'lua', 'go' },

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

-- Config blink
local blink = {
  'saghen/blink.cmp',
  lazy = false, -- lazy loading handled internally
  -- use a release tag to download pre-built binaries
  version = 'v0.*',
  -- build = 'cargo build --release',
  config = function()
    -- if last char is number, and the only completion item is provided by rime-ls, accept it
    require('blink.cmp.completion.list').show_emitter:on(function(event)
      if #event.items ~= 1 then return end
      local col = vim.fn.col('.') - 1
      if event.context.line:sub(1, col):match("^.*%a+%d+$") == nil then return end
      local client = vim.lsp.get_client_by_id(event.items[1].client_id)
      if (not client) or client.name ~= "rime_ls" then return end
      require('blink.cmp').accept({ index = 1 })
    end)

    -- link BlinkCmpKind to CmpItemKind since nvchad/base46 does not support it
    local set_hl = function(hl_group, opts)
      opts.default = true -- Prevents overriding existing definitions
      vim.api.nvim_set_hl(0, hl_group, opts)
    end
    for _, kind in ipairs(require('blink.cmp.types').CompletionItemKind) do
      set_hl('BlinkCmpKind' .. kind, { link = 'CmpItemKind' .. kind or 'BlinkCmpKind' })
    end

    require('blink.cmp').setup {
      keymap = {
        preset = 'enter', -- 'default', 'super-tab', 'enter'
        ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
        ['<C-y>'] = { 'show', 'select_and_accept' },
      },
      completion = {
        documentation = {
          auto_show = true
        },
        menu = {
          auto_show = function(ctx) return ctx.mode ~= 'cmdline' end,
          draw = {
            columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
          },
          border = "single",
          winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None,FloatBorder:CmpBorder",
        }
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lsp = {
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                if item.kind == require('blink.cmp.types').CompletionItemKind.Snippet then
                  item.score_offset = item.score_offset - 3
                end
              end
              return items
            end
          }
        },
      },
    }
  end,
}

-- Autopairs
local autopairs = {
  'windwp/nvim-autopairs',
  event = "InsertEnter",
  config = true
}

-- Tabout
local tabout = {
  'abecodes/tabout.nvim',
  lazy = false,
  config = true,
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
  event = "LazyFile",
  dependencies = {
    -- Setup lsp installed in mason
    'williamboman/mason-lspconfig.nvim',
    -- Useful status updates for LSP
    { 'j-hui/fidget.nvim', config = true },
  },
  config = function()
    -- LSP settings.
    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(client, bufnr)
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      -- nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<leader>rn', require('nvchad.lsp.renamer'), '[R]e[n]ame')
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

      -- inlay hint
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true)
      end

      -- code lens
      if client.server_capabilities.codeLensProvider then
        vim.lsp.codelens.refresh({ bufnr = bufnr })
        vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
          buffer = bufnr,
          callback = function()
            vim.lsp.codelens.refresh({ bufnr = bufnr })
          end,
        })
      end

    end

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
    -- force utf-8
    capabilities.general.positionEncodings = { 'utf-8', 'utf-16' }

    -- Load mason_lspconfig
    require('mason-lspconfig').setup_handlers {
      function(server_name)
        require('lspconfig')[server_name].setup {
          offset_encoding = "utf-8", -- wtf? if not set, it shows warning
          capabilities = capabilities,
          on_attach = on_attach,
        }
      end,
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
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        javascript = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
    })
  end,
}

-- Config illuminate
local illuminate = {
  'RRethy/vim-illuminate',
  event = "LazyFile",
  config = function()
    require("illuminate").configure({
      delay = 200,
      large_file_cutoff = 2000,
      filetypes_denylist = {
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
    -- better selection ui
    { 'nvim-telescope/telescope-ui-select.nvim' },
  },
  init = function()
    -- Keymap for toggling telescope
    vim.keymap.set('n', '<C-p>', function()
      local builtin = require('telescope.builtin')
      vim.fn.system('git rev-parse --is-inside-work-tree')
      if vim.v.shell_error == 0 then builtin.git_files() else builtin.find_files() end
    end, { desc = 'Ctrl-P: search editable files' })
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
    vim.keymap.set('n', '<leader>b', "<cmd>Telescope buffers<cr>", { desc = 'search [B]uffers' })
    vim.keymap.set('n', '<leader>?', "<cmd>Telescope oldfiles<cr>", { desc = 'Find recent files' })

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
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown()
        }
      }
    }
    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
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

-- Config nvchad
local nvchad_ui = {
  "nvchad/ui",
  lazy = false,
  config = function()
    require "nvchad"

    -- global statusline
    vim.opt.laststatus = 3

    -- set keymaps to easily move between buffers and terminal
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    end
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

    vim.keymap.set('n', '<leader>t', function() require('nvchad.term').toggle { pos = "bo sp", id = "tt" } end, { desc = '[t]erminal' })
    vim.keymap.set('n', '<leader>T', function() require('nvchad.term').toggle { pos = "vsp", id = "tT" } end, { desc = '[T]erminal vertical' })
    vim.keymap.set('n', '<C-t>', function()  require('nvchad.term').toggle { pos = "float", id = "tf" } end, { desc = '[t]erminal floating' })
  end
}

local nvchad_base46 = {
  "nvchad/base46",
  build = function()
    require("base46").load_all_highlights()
  end,
}

-- Config Lazy
local lazy_plugins = {
  -- Themes
  nvchad_base46,

  -- UI related
  nvchad_ui,
  indent_blankline,
  gitsigns,
  neotree,
  whichkey,

  -- Coding
  treesitter,
  blink,
  autopairs,
  tabout,
  mason,
  lspconfig,
  conform,
  illuminate,
  { 'tpope/vim-sleuth', event = "LazyFile" },

  -- Language specific
  vimtex,

  -- Fuzzy Finder (files, lsp, etc)
  telescope,
}

local lazy_config = {
  defaults = { lazy = true },
}

-- Copy from LazyVim
local lazy_file = function ()
  -- This autocmd will only trigger when a file was loaded from the cmdline.
  -- It will render the file as quickly as possible.
  vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = function(event)
      -- Skip if we already entered vim
      if vim.v.vim_did_enter == 1 then
        return
      end

      -- Try to guess the filetype (may change later on during Neovim startup)
      local ft = vim.filetype.match({ buf = event.buf })
      if ft then
        -- Add treesitter highlights and fallback to syntax
        local lang = vim.treesitter.language.get_lang(ft)
        if not (lang and pcall(vim.treesitter.start, event.buf, lang)) then
          vim.bo[event.buf].syntax = ft
        end

        -- Trigger early redraw
        vim.cmd([[redraw]])
      end
    end,
  })

  -- Add support for the LazyFile event
  local Event = require("lazy.core.handler.event")
  local lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }
  Event.mappings.LazyFile = { id = "LazyFile", event = lazy_file_events }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

lazy_file()
require('lazy').setup(lazy_plugins, lazy_config)

-- nvchad theme
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
 dofile(vim.g.base46_cache .. v)
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
