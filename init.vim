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
    "ray-x/aurora",
    "nvim-lualine/lualine.nvim",
    "tpope/vim-fugitive",
    "lewis6991/gitsigns.nvim",
    {"iamcco/markdown-preview.nvim", ft = "markdown", build = "cd app && yarn install" },
    "preservim/nerdcommenter",
    "windwp/nvim-autopairs",
    "mhinz/vim-startify",
    {"lervag/vimtex", ft = "tex"},
    "nvim-treesitter/nvim-treesitter", -- {"do": ":TSUpdate"},
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
    "p00f/nvim-ts-rainbow",
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
     "theHamsta/nvim-dap-virtual-text",
     "rcarriga/nvim-dap-ui",
     {"ms-jpq/coq_nvim", branch = "coq"},
     {"ms-jpq/coq.artifacts", branch = "artifacts"},
     "kyazdani42/nvim-web-devicons",
     "kyazdani42/nvim-tree.lua",
     "nvim-lua/plenary.nvim",
     "jose-elias-alvarez/null-ls.nvim",
     { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
     "nvim-telescope/telescope.nvim",
     {"mfussenegger/nvim-jdtls", ft="java"},
     "lukas-reineke/indent-blankline.nvim",
     "kylechui/nvim-surround",
     "sindrets/diffview.nvim",
     "rmagatti/goto-preview",
     "simrat39/symbols-outline.nvim",
     "RRethy/vim-illuminate",
     {"simrat39/rust-tools.nvim", ft="rust"},
     {"L3MON4D3/LuaSnip", version =  "2.*", build =  "make install_jsregexp"} ,
     "ggandor/leap.nvim",
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
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    },
})
EOF

"set fileencodings=utf-8,gbk
set termguicolors
let mapleader = ","
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set nu
set relativenumber
set hidden
set nowrap
set noerrorbells
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

" syntax on

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

" Remap command line window
"nnoremap :: q:

" easy expansion of the active file directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p:h').'/' : '%%'

let g:aurora_italic = 1     " italic
let g:aurora_transparent = 1     " transparent
let g:aurora_bold = 1     " bold
let g:aurora_darker = 1     " darker background

colorscheme aurora

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
      if vim.wo.diff then return ']h' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[h', function()
      if vim.wo.diff then return '[h' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
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
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "all",

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = { "swift" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
    incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = '<CR>',
      node_decremental = '<BS>',
      scope_incremental = '<TAB>',
    }
  },
  indent = {
    enable = false
  },
    rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = 200, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  }
}

-- zc folding
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.wo.foldlevel = 99

require'treesitter-context'.setup()
EOF


"-----------------------end treesitter-------------

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
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

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
  end,
})

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'ltex','bashls','gopls','pyright', 'tsserver',
'ccls', 'jsonls', 'lemminx', 'vimls', 'taplo'}
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end

EOF
"---------------end lsp------------------

" -------------rust tools --------------
lua << EOF
local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})
EOF
"  --------------end rust tools-=---------

"-------------------coq-----------------
" set jump_to_mark to a key
let g:coq_settings = { 'auto_start': v:true, 'keymap.jump_to_mark': '<c-\>'}

"------------------end coq-----------------

"----------------------null-ls-----------------
"lua << EOF
  "require("null-ls").setup({
  "debug = false,
    "sources = {
        "require("null-ls").builtins.formatting.black.with({ extra_args = {"--fast", "-l 79"} }),
        "require("null-ls").builtins.diagnostics.flake8
    "},
"})
"EOF
"---------------------end null-ls---------

" ------------------telescope----------------------
" Find files using Telescope command-line sugar.

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
"
"===================symbol outline----------------
lua << EOF
require("symbols-outline").setup()
EOF
"--------------------symbol outline end-------------------

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
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
EOF
"---------------------end dap-----------------------


"---------------------start word illuminate --------------------
"----------------------end word illuminate

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
vim.keymap.set("i", "<c-j>", "<cmd>lua require('luasnip').jump(1)<CR>")
vim.keymap.set("s", "<c-j>", "<cmd>lua require('luasnip').jump(1)<CR>")
vim.keymap.set("i", "<c-k>", "<cmd>lua require('luasnip').jump(-1)<CR>")
vim.keymap.set("s", "<c-k>", "<cmd>lua require('luasnip').jump(-1)<CR>")
EOF

"  -----------------end luasnip------------

" ----------------start ident_blankline---------------
lua << EOF
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}
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
lua require('leap').add_default_mappings()

"lua << EOF
""vim.g.copilot_no_tab_map = true
""vim.g.copilot_assume_mapped = true
"EOF

set spell
set spelllang=nl,en_us,cjk
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

