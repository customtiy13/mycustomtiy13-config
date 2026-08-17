-- ~/.config/nvim/init.lua
-- Target: Neovim 0.11.x
-- Single-file config: lazy.nvim + LSP + completion + search + git + debug

-- =========================================================
-- Leader
-- =========================================================
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- =========================================================
-- Options
-- =========================================================
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.cursorcolumn = false

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.wrap = false
opt.scrolloff = 6
opt.sidescrolloff = 4

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.mouse = ""

opt.splitright = true
opt.splitbelow = true

opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

opt.updatetime = 250
opt.timeoutlen = 300
opt.history = 1000
opt.colorcolumn = "80"
opt.confirm = true

-- Better command-line completion
opt.wildmode = "longest:full,full"
opt.shortmess:append("I")

-- Keep one global statusline
opt.laststatus = 3

-- =========================================================
-- Helpers
-- =========================================================
local map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- =========================================================
-- General keymaps
-- =========================================================

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")

-- Keep cursor centered while paging/searching
map("n", "<C-d>", "<C-d>zz", "Half page down")
map("n", "<C-u>", "<C-u>zz", "Half page up")
map("n", "n", "nzzzv", "Next search result")
map("n", "N", "Nzzzv", "Previous search result")

-- Save
map("n", "<leader>w", "<cmd>write<CR>", "Save file")

-- Move selected lines
map("v", "J", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move selection up")

-- Quickfix / location list
map("n", "[q", "<cmd>cprev<CR>", "Previous quickfix")
map("n", "]q", "<cmd>cnext<CR>", "Next quickfix")
map("n", "[l", "<cmd>lprev<CR>", "Previous location")
map("n", "]l", "<cmd>lnext<CR>", "Next location")

-- Buffers
map("n", "[b", "<cmd>bprevious<CR>", "Previous buffer")
map("n", "]b", "<cmd>bnext<CR>", "Next buffer")
map("n", "<leader>bd", "<cmd>bdelete<CR>", "Delete buffer")

-- Keep * from polluting jump list
map("n", "*", function()
  vim.cmd("keepjumps normal! mi*`i")
end, "Search word under cursor")

-- Expand current file directory on command line with %%
vim.keymap.set("c", "%%", function()
  if vim.fn.getcmdtype() == ":" then
    return vim.fn.expand("%:p:h") .. "/"
  end
  return "%%"
end, { expr = true, desc = "Current file directory" })

-- =========================================================
-- Autocommands
-- =========================================================

local group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

-- Spellcheck only prose-oriented filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "markdown", "text", "tex", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en_us", "cjk" }
  end,
})

-- 2-space indentation where it is conventional
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = {
    "lua",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "jsonc",
    "yaml",
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Close a few utility windows with q
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "help", "qf", "checkhealth", "man" },
  callback = function(ev)
    vim.keymap.set("n", "q", "<cmd>close<CR>", {
      buffer = ev.buf,
      silent = true,
      desc = "Close window",
    })
  end,
})

-- =========================================================
-- lazy.nvim bootstrap
-- =========================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    error("Failed to clone lazy.nvim:\n" .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

-- =========================================================
-- Plugins
-- =========================================================
require("lazy").setup({
  {
    "neovim/nvim-lspconfig",
    lazy = false,
  },
  -- -------------------------------------------------------
  -- UI
  -- -------------------------------------------------------
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        globalstatus = true,
        theme = "auto",
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 300,
    },
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<CR>", desc = "Zen mode" },
    },
    opts = {},
  },

  -- -------------------------------------------------------
  -- Files
  -- -------------------------------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },

    keys = {
      {
        "<leader>e",
        "<cmd>Neotree toggle reveal<CR>",
        desc = "Explorer",
      },
      {
        "<leader>E",
        "<cmd>Neotree reveal<CR>",
        desc = "Reveal current file",
      },
    },

    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,

      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },

        use_libuv_file_watcher = true,

        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
      },

      window = {
        position = "left",
        width = 34,

        mappings = {
          ["<space>"] = "none",
          ["l"] = "open",
          ["h"] = "close_node",
          ["H"] = "toggle_hidden",
          ["q"] = "close_window",
          ["<CR>"] = "open",
        },
      },

      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
        },

        git_status = {
          symbols = {
            added = "✚",
            modified = "",
            deleted = "✖",
            renamed = "󰁕",
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },
      },
    },
  },

  -- -------------------------------------------------------
  -- Search
  -- -------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          path_display = { "truncate" },
          layout_config = {
            horizontal = {
              preview_width = 0.55,
            },
          },
          mappings = {
            i = {
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
            },
            n = {
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
            },
          },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true,
          },
          ["ui-select"] = require("telescope.themes").get_dropdown({}),
        },
      })

      pcall(telescope.load_extension, "fzf")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("ui-select")
    end,
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({ hidden = true })
        end,
        desc = "Find files",
      },
      {
        "<leader>fa",
        function()
          require("telescope.builtin").find_files({
            hidden = true,
            no_ignore = true,
          })
        end,
        desc = "Find all files",
      },
      {
        "<leader>fi",
        function()
          require("telescope.builtin").git_files()
        end,
        desc = "Find git files",
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Find buffers",
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Find help",
      },
      {
        "<leader>fc",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find()
        end,
        desc = "Search current buffer",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Live grep",
      },
      {
        "<leader>fs",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "Live grep with args",
      },
      {
        "<leader>fd",
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>ss",
        function()
          require("telescope.builtin").lsp_document_symbols()
        end,
        desc = "Document symbols",
      },
      {
        "<leader>sS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols()
        end,
        desc = "Workspace symbols",
      },
      {
        "gR",
        function()
          require("telescope.builtin").lsp_references()
        end,
        desc = "LSP references",
      },
    },
  },

  -- -------------------------------------------------------
  -- Treesitter (main branch, Neovim >= 0.12)
  -- -------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      local parsers = {
        "bash",
        "c",
        "cpp",
        "go",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      }

      -- Asynchronous and a no-op for already installed parsers.
      ts.install(parsers)

      -- Highlighting is now a native Neovim Treesitter feature.
      local ts_filetypes = {
        "bash",
        "c",
        "cpp",
        "go",
        "javascript",
        "javascriptreact",
        "json",
        "jsonc",
        "lua",
        "markdown",
        "python",
        "rust",
        "toml",
        "typescript",
        "typescriptreact",
        "vim",
        "yaml",
      }

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
        pattern = ts_filetypes,
        callback = function(ev)
          -- Parser installation is async; don't make first startup fail.
          pcall(vim.treesitter.start, ev.buf)

          -- Treesitter indentation remains experimental.
          pcall(function()
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end)
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = false,
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
          },
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true,
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      map({ "x", "o" }, "af", function()
        select.select_textobject("@function.outer", "textobjects")
      end, "Around function")

      map({ "x", "o" }, "if", function()
        select.select_textobject("@function.inner", "textobjects")
      end, "Inside function")

      map({ "x", "o" }, "ac", function()
        select.select_textobject("@class.outer", "textobjects")
      end, "Around class")

      map({ "x", "o" }, "ic", function()
        select.select_textobject("@class.inner", "textobjects")
      end, "Inside class")

      map({ "x", "o" }, "aa", function()
        select.select_textobject("@parameter.outer", "textobjects")
      end, "Around argument")

      map({ "x", "o" }, "ia", function()
        select.select_textobject("@parameter.inner", "textobjects")
      end, "Inside argument")

      map({ "n", "x", "o" }, "]m", function()
        move.goto_next_start("@function.outer", "textobjects")
      end, "Next function")

      map({ "n", "x", "o" }, "[m", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end, "Previous function")

      map({ "n", "x", "o" }, "]]", function()
        move.goto_next_start("@class.outer", "textobjects")
      end, "Next class")

      map({ "n", "x", "o" }, "[[", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end, "Previous class")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      max_lines = 4,
      multiline_threshold = 2,
    },
  },

  -- -------------------------------------------------------
  -- Editing
  -- -------------------------------------------------------
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 150,
          window = {
            border = "rounded",
          },
        },
        menu = {
          border = "rounded",
        },
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = {
        implementation = "prefer_rust",
      },
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt" },
      fast_wrap = {
        map = "<M-e>",
      },
    },
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  {
    url = "https://codeberg.org/andyg/leap.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Leap forward" },
      { "S", mode = { "n", "x", "o" }, desc = "Leap from window" },
    },
    config = function()
      map({ "n", "x", "o" }, "s", "<Plug>(leap)", "Leap")
      map({ "n", "x", "o" }, "S", "<Plug>(leap-from-window)", "Leap from window")
    end,
  },

  -- -------------------------------------------------------
  -- Git
  -- -------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function bmap(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            desc = desc,
          })
        end

        bmap("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next git hunk")

        bmap("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Previous git hunk")

        bmap("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
        bmap("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        bmap("v", "<leader>gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage hunk")
        bmap("v", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset hunk")

        bmap("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        bmap("n", "<leader>gb", gs.blame_line, "Blame line")
        bmap("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle line blame")
        bmap("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
        bmap("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
      end,
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
    },
  },

  -- -------------------------------------------------------
  -- Terminal
  -- -------------------------------------------------------
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    },
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
      shade_terminals = true,
      float_opts = {
        border = "rounded",
      },
    },
  },

  -- -------------------------------------------------------
  -- Markdown / Typst / LaTeX
  -- -------------------------------------------------------
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    priority = 50,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      preview = {
        filetypes = { "markdown", "quarto", "rmd" },
        ignore_buftypes = { "nofile" },
      },
    },
  },

  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    opts = {},
  },

  {
    "lervag/vimtex",
    ft = "tex",
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_ignore_filters = {
        "Warning.*Fandol",
        "Overfull",
        "Underfull",
        "Warning.*Font",
        "Warning.*Ignoring empty",
        "Warning.*\\headheight is too",
        "Warning.*font",
      }
      vim.g.vimtex_compiler_latexmk_engines = {
        _ = "-xelatex --shell-escape",
        xelatex = "-xelatex --shell-escape",
        pdflatex = "-pdf --shell-escape",
        lualatex = "-lualatex --shell-escape",
      }
    end,
  },

  -- -------------------------------------------------------
  -- Debugging
  -- -------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dn", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dq", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Open REPL" },
    },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {},
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
          local python = vim.fn.exepath("python3")
          if python == "" then
            python = "python"
          end
          require("dap-python").setup(python)
        end,
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      local lldb = vim.fn.exepath("lldb-dap")
      if lldb == "" then
        lldb = vim.fn.exepath("lldb-vscode")
      end

      if lldb ~= "" then
        dap.adapters.lldb = {
          type = "executable",
          command = lldb,
          name = "lldb",
        }

        dap.configurations.cpp = {
          {
            name = "Launch",
            type = "lldb",
            request = "launch",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
          },
        }

        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp
      end
    end,
  },

}, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  ui = {
    border = "rounded",
  },
})

-- =========================================================
-- Diagnostics
-- =========================================================
vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  signs = true,
  virtual_text = {
    spacing = 2,
    source = "if_many",
  },
  float = {
    border = "rounded",
    source = true,
  },
})

map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, "Previous diagnostic")

map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, "Next diagnostic")

map("n", "<leader>de", vim.diagnostic.open_float, "Line diagnostic")
map("n", "<leader>xq", vim.diagnostic.setqflist, "Diagnostics to quickfix")

-- =========================================================
-- LSP (Neovim 0.11 native config API)
-- =========================================================

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
      },
    },
  },
})

local servers = {
  "bashls",
  "clangd",
  "gopls",
  "jsonls",
  "lua_ls",
  "pyright",
  "ruff",
  "rust_analyzer",
  "taplo",
  "ts_ls",
  "yamlls",
}

for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    local function lmap(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, {
        buffer = bufnr,
        silent = true,
        desc = desc,
      })
    end

    lmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
    lmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    lmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    lmap("n", "K", vim.lsp.buf.hover, "Hover documentation")
    lmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    lmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    lmap("n", "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format buffer")

    if client and client:supports_method("textDocument/documentHighlight") then
      local hl_group = vim.api.nvim_create_augroup(
        "LspDocumentHighlight_" .. bufnr,
        { clear = true }
      )

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = hl_group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = hl_group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = hl_group,
        buffer = bufnr,
        once = true,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end

    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

      lmap("n", "<leader>th", function()
        local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
        vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
      end, "Toggle inlay hints")
    end
  end,
})

-- =========================================================
-- Highlight tweaks
-- =========================================================
vim.api.nvim_set_hl(0, "LspReferenceText",  { bg = "#3b4261", bold = true })
vim.api.nvim_set_hl(0, "LspReferenceRead",  { bg = "#3b4261", bold = true })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#3b4261", bold = true })


-- 大文件保护
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function(ev)
    local ok, stat = pcall(vim.uv.fs_stat, ev.file)

    if ok and stat and stat.size > 2 * 1024 * 1024 then
      vim.b[ev.buf].bigfile = true
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(ev)
    if vim.b[ev.buf].bigfile then
      vim.diagnostic.enable(false, { bufnr = ev.buf })
      vim.opt_local.spell = false
      pcall(vim.treesitter.stop, ev.buf)
    end
  end,
})

-- 恢复上次光标位置
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(ev.buf)

    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 窗口切换
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- 自动 resize split
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})
