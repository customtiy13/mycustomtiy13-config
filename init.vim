" Plug
call plug#begin('~/.vim/plugged')

    Plug 'ray-x/aurora'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'tpope/vim-fugitive'
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
    Plug 'preservim/nerdcommenter'
    Plug 'windwp/nvim-autopairs'
    Plug 'mhinz/vim-startify'
    Plug 'lervag/vimtex'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'nvim-treesitter/nvim-treesitter-context'
    Plug 'p00f/nvim-ts-rainbow'
    Plug 'neovim/nvim-lspconfig'
    Plug 'mfussenegger/nvim-dap'
    Plug 'theHamsta/nvim-dap-virtual-text'
    Plug 'rcarriga/nvim-dap-ui'
    Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
    Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'kyazdani42/nvim-tree.lua'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'jose-elias-alvarez/null-ls.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'mfussenegger/nvim-jdtls'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'kylechui/nvim-surround'
    Plug 'sindrets/diffview.nvim'
    Plug 'rmagatti/goto-preview'
    Plug 'simrat39/symbols-outline.nvim'
    Plug 'RRethy/vim-illuminate'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'ggandor/leap.nvim'
    Plug 'folke/zen-mode.nvim'


call plug#end()

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
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  }
}

-- zc folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldlevel = 99

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
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
  
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'ltex','bashls','gopls','pyright', 'tsserver',
'ccls', 'jsonls', 'lemminx', 'vimls'}
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end

require('lspconfig')['rust_analyzer'].setup {
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {}
    }
}
EOF
"---------------end lsp------------------

"-------------------coq-----------------
" set jump_to_mark to a key
let g:coq_settings = { 'auto_start': v:true, 'keymap.jump_to_mark': '<c-\>'}

"------------------end coq-----------------

"----------------------null-ls-----------------
lua << EOF
  require("null-ls").setup({
  debug = false,
    sources = {
        require("null-ls").builtins.formatting.black.with({ extra_args = {"--fast", "-l 79"} }),
        require("null-ls").builtins.diagnostics.flake8
    },
})
EOF
"---------------------end null-ls---------

" ------------------telescope----------------------
" Find files using Telescope command-line sugar.
lua << EOF
require("telescope").setup{}
require('telescope').load_extension('fzf')
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
"
"===================symbol outline----------------
lua << EOF
require("symbols-outline").setup()
EOF
"--------------------symbol outline end-------------------

"-------------------start dap----------------
lua <<EOF
require("dapui").setup()
require("nvim-dap-virtual-text").setup()
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
require("luasnip").config.set_config({
    enable_autosnippets = true,
    store_selection_keys = "<Tab>",
})
EOF
" Expand or jump in insert mode
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
 
" Jump forward through tabstops in visual mode
smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'
" Jump backward through snippet tabstops with Shift-Tab (for example)
imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
" Cycle forward through choice nodes with Control-f (for example)
imap <silent><expr> <C-f> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>'
smap <silent><expr> <C-f> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>'



"  -----------------end luasnip------------


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


set spell
set spelllang=nl,en_us,cjk
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
