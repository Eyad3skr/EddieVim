-- General Settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.o.completeopt = "menu,menuone,noselect"

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
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
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
}

-- Lazy.nvim setup
require("lazy").setup(plugins)

-- Mason Setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "biome", "clangd", "rust_analyzer", "jdtls", "pyright" },
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
  [[✨ Ah yes, another masterpiece of spaghetti]],
  [[code for future archaeologists to decipher ✨]],
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
local lspconfig = require("lspconfig")

-- define ONCE (remove any duplicates elsewhere)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(client, bufnr)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { buffer = bufnr })
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, { buffer = bufnr })
end

-- servers all reuse the same capabilities
lspconfig.lua_ls.setup({ on_attach = on_attach, capabilities = capabilities })

lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = "clippy" },
    },
  },
})

lspconfig.jdtls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/jdtls" },
})

lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = { python = { pythonPath = "/path/to/python3" } },
})



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

vim.keymap.set('n', '<C-p>', require("telescope.builtin").find_files, {})
vim.keymap.set('n', '<leader>fg', require("telescope.builtin").live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>')

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

vim.g.catppuccin_flavour = "mocha"

-- Colorscheme
require("catppuccin").setup()
vim.cmd("colorscheme catppuccin")
