-- General Settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.o.completeopt = "menu,menuone,noselect"
-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Step jumps
vim.keymap.set('n', '<C-j>', '5j', { noremap = true, silent = true, desc = 'Jump down 5 lines' })
vim.keymap.set('n', '<C-k>', '5k', { noremap = true, silent = true, desc = 'Jump up 5 lines' })

-- Smarter j/k for wrapped lines
vim.keymap.set('n', 'j', 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })
vim.keymap.set('n', 'k', 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })

-- Leave terminal mode easily
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Allow moving between splits from terminal
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]])
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]])
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]])
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]])

-- Ensure lazy.nvim is loaded
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
local plugins = {
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-lua/plenary.nvim" },
  {"nvim-treesitter/playground"},
  { "windwp/nvim-autopairs" },
  { "windwp/nvim-ts-autotag" },
  { "numToStr/Comment.nvim", opts = {} },
  { "coder/claudecode.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  {
    'nvim-telescope/telescope.nvim', 
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-ui-select.nvim' },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },  
    -- LSP + Mason
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim", dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" } },

  -- none-ls (replacement for null-ls)
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- (optional) auto-install formatters/linters through Mason
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
  },
  { "rebelot/kanagawa.nvim", priority = 1000 },
  -- Auto-completion plugins
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional: For file icons
  },  

  {
    --toggle terminal plugin
    {'akinsho/toggleterm.nvim', version = "*", config = true}
  },
  { 
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  },

  -- Copilot ↔ nvim-cmp bridge
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
  },
}

-- Lazy.nvim setup
require("lazy").setup(plugins, {
  rocks = {
    enabled = false,
  },
})

-- Copilot core
require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,        -- pop suggestions as you type
    debounce = 150,
    keymap = {
      accept = "<C-l>",         -- accept suggestion
      next = "<M-]>",           -- next suggestion (Alt+])
      prev = "<M-[>",           -- previous suggestion (Alt+[)
      dismiss = "<C-]>",        -- dismiss inline suggestion
    },
  },
  panel = { enabled = false },  -- keep the side panel off (inline only)
  filetypes = {
    -- enable everywhere by default
    ["*"] = true,
    -- examples if you want to disable in some places:
    -- markdown = false,
    -- sql = false,
  },
})

-- Make Copilot a completion source for nvim-cmp
require("copilot_cmp").setup()


-- Indentation behaviour
vim.opt.autoindent = true
vim.opt.smartindent = true  -- smarter {}-aware indent for many langs

-- Treesitter autotag (optional; for HTML/TSX)
require("nvim-treesitter.configs").setup({
  -- keep your existing ensure_installed / highlight / indent...
  autotag = { enable = true },
})

-- nvim-autopairs
require("nvim-autopairs").setup({
  check_ts = true,        -- use treesitter awareness
  enable_check_bracket_line = true,
  fast_wrap = {},
})

-- integrate autopairs with nvim-cmp
local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

-- Mason Setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "biome", "clangd", "rust_analyzer", "jdtls", "pyright" },
})

require("neo-tree").setup({
  log_level = "info",   -- or "warn", "error"
  filesystem = {
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true, -- enables real-time updates
  },
})

-- Alpha.nvim Configuration
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set Header (Eyad in ASCII Art)
dashboard.section.header.val = {
  [[ ██████   █████                                ███                 ]],
  [[░░██████ ░░███                                ░░░                  ]],
  [[ ░███░███ ░███   ██████   ██████  █████ █████ ████  █████████████  ]],
  [[ ░███░░███░███  ███░░███ ███░░███░░███ ░░███ ░░███ ░░███░░███░░███ ]],
  [[ ░███ ░░██████ ░███████ ░███ ░███ ░███  ░███  ░███  ░███ ░███ ░███ ]],
  [[ ░███  ░░█████ ░███░░░  ░███ ░███ ░░███ ███   ░███  ░███ ░███ ░███ ]],
  [[ █████  ░░█████░░██████ ░░██████   ░░█████    █████ █████░███ █████]],
  [[░░░░░    ░░░░░  ░░░░░░   ░░░░░░     ░░░░░    ░░░░░ ░░░░░ ░░░ ░░░░░ ]],
  [[                                                                    ]],
  [[                                                                    ]],
  [[                                                                    ]],
}

-- Set Menu
dashboard.section.buttons.val = {
  dashboard.button("e", "📄  New file", ":ene <BAR> startinsert<CR>"),
  dashboard.button("f", "📂  Find file", ":Telescope find_files<CR>"),
  dashboard.button("r", "🕑  Recent files", ":Telescope oldfiles<CR>"),
  dashboard.button("s", "⚙️  Settings", ":e $MYVIMRC<CR>"),
  dashboard.button("q", "❌  Quit", ":qa<CR>"),
}

-- Footer
dashboard.section.footer.val = {
  "🎉 Welcome to Neovim, Eyad!",
}

-- Add Separator (UI Enhancement)
table.insert(dashboard.section.buttons.val, 1, { type = "padding", val = 2 })
table.insert(dashboard.section.buttons.val, #dashboard.section.buttons.val + 1, { type = "padding", val = 2 })

-- Footer (ASCII Art in Footer)
dashboard.section.footer.val = {
  [[─────────────────────────────────────────────]],
  [[        I came, I saw, I refactored. ⚔️]],
  [[─────────────────────────────────────────────]],
  [[       ⢀⡴⠑⡄⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[       ⠸⡇⠀⠿⡀⠀⠀⠀⣀⡴⢿⣿⣿⣿⣿⣿⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[    ⠀⠀    ⠀⠀⠑⢄⣠⠾⠁⣀⣄⡈⠙⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[       ⠀⠀⠀⠀⢀⡀⠁⠀⠀⠈⠙⠛⠂⠈⣿⣿⣿⣿⣿⠿⡿⢿⣆⠀⠀⠀⠀⠀⠀⠀]],
  [[        ⠀⠀⠀⢀⡾⣁⣀⠀⠴⠂⠙⣗⡀⠀⢻⣿⣿⠭⢤⣴⣦⣤⣹⠀⠀⠀⢀⢴⣶⣆]],
  [[       ⠀⠀⢀⣾⣿⣿⣿⣷⣮⣽⣾⣿⣥⣴⣿⣿⡿⢂⠔⢚⡿⢿⣿⣦⣴⣾⠁⠸⣼⡿]],
  [[       ⠀⢀⡞⠁⠙⠻⠿⠟⠉⠀⠛⢹⣿⣿⣿⣿⣿⣌⢤⣼⣿⣾⣿⡟⠉⠀⠀⠀⠀⠀]],
  [[        ⠀⣾⣷⣶⠇⠀⠀⣤⣄⣀⡀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀]],
  [[       ⠀⠉⠈⠉⠀⠀⢦⡈⢻⣿⣿⣿⣶⣶⣶⣶⣤⣽⡹⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀]],
  [[    ⠀⠀    ⠀⠀⠀⠀⠀⠉⠲⣽⡻⢿⣿⣿⣿⣿⣿⣿⣷⣜⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀]],
  [[    ⠀⠀⠀⠀⠀⠀    ⠀⠀⢸⣿⣿⣷⣶⣮⣭⣽⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀]],
  [[    ⠀⠀    ⠀⠀⠀⠀⣀⣀⣈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀   ⠀    ⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀        ⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀       ⠀⠉⠛⠻⠿⠿⠿⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
}

-- Setup Alpha
alpha.setup(dashboard.config)




-- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

-- -- Specify the installation path
-- parser_config.install_dir = vim.fn.stdpath("data") .. "/tree-sitter/parsers"

-- LSP Setup  -----------------------------------------
-- local lspconfig = require("lspconfig")

-- LSP Setup (Neovim 0.11+ native API) -------------------

-- define ONCE
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(_, bufnr)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { buffer = bufnr })
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, { buffer = bufnr })
end

-- lua_ls
vim.lsp.config("lua_ls", {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- rust_analyzer (keep your special behavior)
vim.lsp.config("rust_analyzer", {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)

    vim.api.nvim_create_autocmd("BufWritePost", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.execute_command({
          command = "rust-analyzer.reloadWorkspace",
          arguments = {},
        })
      end,
    })
  end,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      check = { command = "clippy" },
      diagnostics = {
        enable = true,
        experimental = { enable = true },
      },
    },
  },
})

-- jdtls
vim.lsp.config("jdtls", {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/jdtls" },
})

-- pyright
vim.lsp.config("pyright", {
  on_attach = on_attach,
  capabilities = capabilities,
  -- remove the hardcoded pythonPath unless you really need it
  -- settings = { python = { pythonPath = "..." } },
})

-- finally: enable the servers
vim.lsp.enable({ "lua_ls", "rust_analyzer", "jdtls", "pyright" })


-- define ONCE (remove any duplicates elsewhere)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(client, bufnr)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { buffer = bufnr })
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, { buffer = bufnr })
end

-- rust-analyzer (Neovim 0.11+)
vim.lsp.config("rust_analyzer", {
  on_attach = function(client, bufnr)
    -- your common LSP keymaps
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { buffer = bufnr })
    vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, { buffer = bufnr })

    -- run clippy + update diagnostics after each save
    vim.api.nvim_create_autocmd("BufWritePost", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.execute_command({
          command = "rust-analyzer.reloadWorkspace",
          arguments = {},
        })
      end,
    })
  end,

  capabilities = require("cmp_nvim_lsp").default_capabilities(),

  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      check = { command = "clippy" },
      diagnostics = {
        enable = true,
        experimental = { enable = true },
      },
    },
  },
})


-- jdtls
vim.lsp.config("jdtls", {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/jdtls" },
})

-- pyright
vim.lsp.config("pyright", {
  on_attach = on_attach,
  capabilities = capabilities,
  -- Only keep this if you really need a specific Python path:
  -- settings = { python = { pythonPath = "/path/to/python3" } },
})



vim.lsp.enable({ "rust_analyzer", "jdtls", "pyright", "lua_ls" })

-- servers all reuse the same capabilities
vim.lsp.config("lua_ls", { on_attach = on_attach, capabilities = capabilities })


-- === Treesitter on Windows: use prebuilt DLLs (no compiler) ===
local ts_install = require("nvim-treesitter.install")

-- Don't compile; download prebuilt binaries
ts_install.prefer_git = false

-- IMPORTANT: do NOT set ts_install.compilers at all (no {}, no nil assignment)
-- Leave it untouched so Treesitter keeps its internal default table.

-- Put parsers in a path without spaces (avoids quoting bugs on Windows)
local parser_dir = "C:/nvim-parsers"
vim.fn.mkdir(parser_dir, "p")
ts_install.install_dir = parser_dir
vim.opt.runtimepath:append(parser_dir)

-- Normal Treesitter config
require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "lua", "javascript", "rust", "java", "vim", "vimdoc", "query" },
  auto_install = true,
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
  playground = { enable = true, updatetime = 25, persist_queries = false },
})



-- Telescope Configuration
require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {}
    }
  }
}
require("telescope").load_extension("ui-select")

-- Keymap helper (keep this once)
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- Fast IDE-style bindings
map('n', '<C-f>', require('telescope.builtin').find_files, 'Find Files')
map('n', '<C-g>', require('telescope.builtin').live_grep,  'Live Grep (project)')

-- === Telescope (project-wide) ===
map('n', '<leader>ff', require('telescope.builtin').find_files, 'Find Files')
map('n', '<leader>fg', require('telescope.builtin').live_grep,  'Find Grep (project)')
map('n', '<leader>fb', require('telescope.builtin').buffers,    'Find Buffers')
map('n', '<leader>fh', require('telescope.builtin').help_tags,  'Find Help')

-- Optional: search word under cursor across project
map('n', '<leader>*', require('telescope.builtin').grep_string, 'Grep word under cursor')

-- Optional: search only in current buffer
map('n', '<leader>sb', require('telescope.builtin').current_buffer_fuzzy_find, 'Search in buffer')

-- Keep (or remove) your legacy Ctrl+P if you want
map('n', '<C-p>', require('telescope.builtin').find_files, 'Find Files (legacy)')


-- Telescope
map('n', '<C-p>',        require('telescope.builtin').find_files, 'Find Files (legacy)')

-- Neo-tree (folder tree)
map('n', '<C-n>', function()
  vim.cmd('Neotree filesystem reveal left')
end, 'Neo-tree: Reveal Left')

function _G.set_toggleterm_dir(dir)
  vim.cmd("ToggleTerm size=20 direction=horizontal dir=" .. dir)
end

-- toggle terminal with input:
vim.api.nvim_set_keymap('n', '<C-t>', ':lua _G.set_toggleterm_dir(vim.fn.input("Enter directory: "))<CR>', { noremap = true, silent = true })

-- none-ls (null-ls replacement)
local null = require("null-ls")

null.setup({
  sources = {
    -- formatters
    null.builtins.formatting.stylua,
    null.builtins.formatting.rustfmt,
    null.builtins.formatting.google_java_format,
    -- diagnostics
    null.builtins.diagnostics.eslint_d,  -- faster than eslint (or use eslint if you prefer)
  },
})

vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
    source = "if_many",   -- show source names when useful
    severity_sort = true,
  },
  signs = true,
  underline = true,
  update_in_insert = false, -- don’t distract while typing
  float = { border = "rounded", source = "always" },
})


-- (optional) auto-install those tools via Mason
pcall(function()
  require("mason-null-ls").setup({
    ensure_installed = { "stylua", "google-java-format", "eslint_d" },
    automatic_installation = true,
  })
end)

-- Auto-completion setup
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body) -- For Luasnip users
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
  }),
  sources = cmp.config.sources({
    { name = "copilot",  group_index = 2, priority = 90 },
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
})

-- Completion for `/` and `:` in command line
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- General UI Settings
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = false

-- Colorscheme: Kanagawa
require("kanagawa").setup({
  compile = false, -- set true if you want faster startup (then run :KanagawaCompile)
  undercurl = true,
  commentStyle = { italic = true },
  keywordStyle = { italic = true },
  statementStyle = { bold = true },
  transparent = false,
  dimInactive = false,
  terminalColors = true,
  theme = "wave",  -- "wave", "dragon", "lotus"
  background = {
    dark = "wave",
    light = "lotus",
  },
})

vim.cmd("colorscheme kanagawa-wave") -- or kanagawa-dragon / kanagawa-lotus

