lua << EOF
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
vim.g.mapleader = ","
require("lazy").setup({
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    "nvim-lualine/lualine.nvim",
    'chomosuke/typst-preview.nvim',
    "lewis6991/gitsigns.nvim",
    {"iamcco/markdown-preview.nvim", ft = "markdown", build = "cd app && yarn install" },
    "windwp/nvim-autopairs",
    "mhinz/vim-startify",
    {'akinsho/toggleterm.nvim', version = "*", config = true},
    {
      "andymass/vim-matchup",
      setup = function()
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
      end,
    },
    {"lervag/vimtex", ft = "tex"},
    {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
    },
    {'nvim-treesitter/nvim-treesitter-textobjects', branch="main",
        init = function()
            vim.g.no_plugin_maps = true
              end,
    },
    'nvim-treesitter/nvim-treesitter-context',
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
     "theHamsta/nvim-dap-virtual-text",
     "rcarriga/nvim-dap-ui",
     "nvim-neotest/nvim-nio",
     "nvim-tree/nvim-web-devicons",
     "nvim-tree/nvim-tree.lua",
     "nvim-lua/plenary.nvim",
    {
      'saghen/blink.cmp',
      version = '*', -- 使用稳定版
      dependencies = 'L3MON4D3/LuaSnip', 
      opts = {
        snippets = { preset = 'luasnip' },
        keymap = { preset = 'default',
            ['<CR>'] = { 'accept', 'fallback' }, 
        }, -- 默认快捷键很符合直觉
        appearance = {
          nerd_font_variant = 'mono'
        },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        completion = {
          documentation = {
            auto_show = true,       -- 选中时自动显示文档
            auto_show_delay_ms = 100, -- 延迟 100ms 显示，防止快速滚动时闪烁
            update_delay_ms = 50,     -- 更新文档的速度
            window = {
              border = 'rounded',     -- 给窗口加个圆角边框，更好看
            },
          },
          menu = {
            border = 'rounded',
          }
        },
        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    },
     { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
     "nvim-telescope/telescope.nvim",
     {"mfussenegger/nvim-jdtls", ft="java"},
     { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
     "kylechui/nvim-surround",
     "sindrets/diffview.nvim",
     "rmagatti/goto-preview",
     {"L3MON4D3/LuaSnip", version =  "2.*", build =  "make install_jsregexp"} ,
     { url = "https://codeberg.org/andyg/leap.nvim"},
     "cloudysake/swap-split.nvim",
     "folke/zen-mode.nvim",
     "mfussenegger/nvim-dap-python",
     {
      "folke/which-key.nvim",
      event = "VeryLazy",
      init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end,
      opts = {
      }
    },
})
EOF

set termguicolors
let mapleader = ","
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set nu
set relativenumber
set hidden
set nowrap
set ignorecase
set smartcase
set smartindent
set autoindent
set nobackup
set noswapfile
set nowritebackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=6
set colorcolumn=80
set signcolumn=yes
set history=1000

" hight current line and column,
"  which will make it look like a target cross;
set cursorline
set cursorcolumn
set mouse=


" clear highlight
if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable 
" delays and poor experience
set updatetime=50

" Don't pass messages to |ins-completion-munu|
set shortmess+=c

" Give more space for displaying messages
set cmdheight=1


" easy expansion of the active file directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p:h').'/' : '%%'


colorscheme tokyonight-storm

highlight Normal guibg=none
highlight NonText guibg=none

" quickfix
noremap <silent> [q :cprev<CR>
noremap <silent> ]q :cnext<CR>
" location list
noremap <silent> [l :lprev<CR>
noremap <silent> ]l :lnext<CR>

" buffer list
noremap <silent> [b :bprevious<CR>
noremap <silent> ]b :bnext<CR>
noremap <silent> [B :bfirst<CR>
noremap <silent> ]B :blast<CR>


lua << END
require('lualine').setup()
require 'typst-preview'.setup()
END

"-----------swap splits-----------------
nnoremap <leader>S <cmd>SwapSplit<CR>
"----------end splits-------------------
"
lua << END
_G.StatusColumn = {}
StatusColumn.set_window = function(value, defer, win)
  vim.defer_fn(function()
    win = win or vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_option(win, "statuscolumn", value)
  end, defer or 1)
end
END

"  ----------------git -----------------
lua << EOF
require('gitsigns').setup{
 on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']h', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[h', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk)
    map('n', '<leader>hr', gs.reset_hunk)
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
EOF
" ----------------end git----------------

set clipboard+=unnamedplus

"------------------------treesitter--------------
lua << EOF
require("nvim-treesitter").setup({
  ensure_installed = "all",
  sync_install = false,
  ignore_install = { "swift" },

  highlight = { enable = true, additional_vim_regex_highlighting = false },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = '<CR>',
      node_decremental = '<BS>',
      scope_incremental = '<TAB>',
    }
  },

  indent = { enable = true },

  rainbow = { enable = false, extended_mode = true, max_file_lines = 200 },

  matchup = { enable = true, disable = { "ruby" } },
})

require'treesitter-context'.setup()


require("nvim-treesitter-textobjects").setup {
  select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          -- ['@class.outer'] = '<c-v>', -- blockwise
        },
        include_surrounding_whitespace = false,
      },
    }
    vim.keymap.set({ "x", "o" }, "am", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "im", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "ac", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "ic", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
    end)
    -- You can also use captures from other query groups like `locals.scm`
    vim.keymap.set({ "x", "o" }, "as", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
    end)

    vim.keymap.set({ "n", "x", "o" }, "]m", function()
  require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]]", function()
  require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
end)
-- You can also pass a list to group multiple queries.
vim.keymap.set({ "n", "x", "o" }, "]o", function()
  require("nvim-treesitter-textobjects.move").goto_next_start({"@loop.inner", "@loop.outer"}, "textobjects")
end)
-- You can also use captures from other query groups like `locals.scm` or `folds.scm`
vim.keymap.set({ "n", "x", "o" }, "]s", function()
  require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
end)
vim.keymap.set({ "n", "x", "o" }, "]z", function()
  require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
end)

vim.keymap.set({ "n", "x", "o" }, "]M", function()
  require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "][", function()
  require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "[m", function()
  require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[[", function()
  require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "[M", function()
  require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[]", function()
  require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
end)

-- Go to either the start or the end, whichever is closer.
-- Use if you want more granular movements
vim.keymap.set({ "n", "x", "o" }, "]d", function()
  require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[d", function()
  require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
end)

EOF



" --------------end toggleterm--------------------


"--------------------auto pair---------------------
lua << EOF
require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})
local npairs = require("nvim-autopairs")

-- put this to setup function and press <a-e> to use fast_wrap
npairs.setup({
    fast_wrap = {},
    ts_config = {
        lua = {'string'},-- it will not add a pair on that treesitter node
        javascript = {'template_string'},
        -- java = true,-- don't check treesitter on java
    }

})

-- change default fast_wrap
npairs.setup({
    fast_wrap = {
      map = '<M-e>',
      chars = { '{', '[', '(', '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
      offset = 0, -- Offset from pattern match
      end_key = '$',
      keys = 'qwertyuiopzxcvbnmasdfghjkl',
      check_comma = true,
      highlight = 'Search',
      highlight_grey='Comment'
    },
})

EOF

"-----------------------end pair--------------------


"----------------lsp---------------------------
lua << EOF
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'


    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)

    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)


    if client and client.supports_method("textDocument/documentHighlight") then
      local highlight_group = vim.api.nvim_create_augroup('lsp_document_highlight_' .. bufnr, { clear = true })
      
      -- 注册自动高亮
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = highlight_group,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      })

      -- 注册自动清除
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = highlight_group,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end
  end,
})

local servers = { 'ltex','bashls','gopls', 'ts_ls',
'jsonls','clangd', 'lemminx', 'vimls', 'taplo', "rust_analyzer"}
for _, lsp in pairs(servers) do
    vim.lsp.enable(lsp)
end
vim.lsp.enable('pylsp', {
  settings = {
    pylsp = {
      plugins = {
        black = { enabled = true },    -- Use black for formatting
      },
    },
  },
})
vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())


EOF
"---------------end lsp------------------


" ------------------telescope----------------------
" Find files using Telescope command-line sugar.
"
lua << EOF
local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
      },
      n = {
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
      }
    }
  }
}
EOF

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fi <cmd>Telescope git_files<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fc <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>fd <cmd>Telescope find_files hidden=true no_ignore=true<cr>
nnoremap <leader>xd <cmd>Telescope diagnostics<cr>
nnoremap <leader>xs <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>xq <cmd>Telescope quickfix<cr>
nnoremap <leader>xl <cmd>Telescope loclist<cr>
nnoremap <leader>gc <cmd>Telescope git_commits<cr>
nnoremap <leader>gs <cmd>Telescope git_status<cr>
nnoremap gR <cmd>Telescope lsp_references<cr>



"------------------end telescope-----------------


"------------------start nvim-surround----------------
lua << EOF
    require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
    })
EOF
"-----------------end nvim-surround------------------

"-------------------start dap----------------
lua require('dap-python').setup('~/master/机器学习/venv/bin/python')
lua <<EOF
require("dapui").setup()
require("nvim-dap-virtual-text").setup()
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
vim.keymap.set("n", "<Space>dt", ':DapToggleBreakpoint<CR>')
vim.keymap.set("n", "<Space>dc", ':DapContinue<CR>')
vim.keymap.set("n", "<Space>ds", ':DapStepInto<CR>')
vim.keymap.set("n", "<Space>dS", ':DapStepOut<CR>')
vim.keymap.set("n", "<Space>dq", ':DapTerminate<CR>')

local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
  name = 'lldb'
}
dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {} -- CAHNGE me.
    

  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
EOF
"---------------------end dap-----------------------


lua << EOF
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.opt.termguicolors = true

    require("nvim-tree").setup {
        view = {
            width = 40,
            side="right"
        },
        update_focused_file = {
            enable = true,
            update_cwd = true,
        }
}
EOF

" ----------------luasnip---------
lua << EOF
require("luasnip.loaders.from_vscode").lazy_load()
vim.keymap.set("i", "<c-j>", "<cmd>lua require('luasnip').jump(1)<CR>")
vim.keymap.set("s", "<c-j>", "<cmd>lua require('luasnip').jump(1)<CR>")
vim.keymap.set("i", "<c-k>", "<cmd>lua require('luasnip').jump(-1)<CR>")
vim.keymap.set("s", "<c-k>", "<cmd>lua require('luasnip').jump(-1)<CR>")
EOF

"  -----------------end luasnip------------

" ----------------start ident_blankline---------------
lua << EOF
require("ibl").setup()
EOF

"  ------------------end ident_blankline---------------
"

" =================start zen-mode----------------
lua << EOF
require("zen-mode").setup {
    }
EOF
" -------------------end zen-mode------------------


lua << EOF
require('goto-preview').setup {default_mappings = true}
EOF

nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>


lua << EOF
    vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
    vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
    vim.keymap.set('n', '<leader>h', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)
EOF

let g:vimtex_view_method = 'zathura'
let g:mkdp_page_title = ' '
let g:mkdp_browser = ''
let g:vimtex_quickfix_ignore_filters = [
            \'Warning.*Fandol', 
            \'Overfull', 'Underfull',
            \'Warning.*Font',
            \'Warning.*Ignoring empty',
            \'Warning.*\headheight is too',
            \'Warning.*font'
      \]
let g:vimtex_compiler_latexmk_engines = {
            \'_':'-xelatex --shell-escape',
            \'xelatex': '-xelatex --shell-escape',
            \'pdflatex': '-pdf --shell-escape',
            \'lualatex' : '-lualatex --shell-escape'
            \}

nnoremap * :keepjumps normal! mi*`i<CR>

lua << EOF
vim.diagnostic.config({
  virtual_text = true,
})
EOF
"lua require('leap').add_default_mappings()

set spell
set spelllang=en_us,cjk
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

lua << EOF
vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#3b4261', bold = true })
vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#3b4261', bold = true })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#3b4261', bold = true })
EOF
