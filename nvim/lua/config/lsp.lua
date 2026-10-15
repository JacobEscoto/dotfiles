-- Native LSP Configuration

local lsp_config = {}

local mason_sdk = vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules/typescript/lib"

-- LSP for TypeScript and JavaScript
vim.lsp.config("typescript-language-server", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
  init_options = {
    preferences = {
      quotePreference = "single",
      importModuleSpecifierPreference = "relative",
    },
  },
})

-- LSP for Astro
vim.lsp.config("astro-language-server", {
  cmd = { "astro-ls", "--stdio" },
  filetypes = { "astro" },
  root_markers = { "package.json", "astro.config.mjs", "astro.config.ts", ".git" },
  init_options = {
    typescript = {
      tsdk = mason_sdk,
    },
  },
})

-- LSP for TailwindCSS
vim.lsp.config("tailwindcss", {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = {
    "html",
    "css",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "astro",
  },
  root_markers = {
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "tailwind.config.ts",
    "package.json",
    ".git",
  },
  settings = {
    tailwindCSS = {
      classAttributes = { "class", "className", "class:list", "classList" },
    },
  },
})

-- LSP for Golang
vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
    },
  },
})

-- LSP for Lua
vim.lsp.config("lua-language-server", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", "selene.toml", "stylua.toml" },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        globals = { "vim" },
        disable = { "lowercase-global" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- LSP for Bash scripting
vim.lsp.config("bash-language-server", {
  cmd = { "bash-language-server", "start" },
  filetypes = { "bash", "sh", "zsh" },
  root_markers = { ".git", ".bashrc", ".bash_profile" },
  settings = {
    bashIde = {
      globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
    },
  },
})

-- LSP for C/C++
vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_markers = {
    "compile_commands.json",
    "compile_flags.txt",
    ".clang-d",
    ".git",
  },
})

-- LSP for Rust
vim.lsp.config("rust-analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Anchor.toml", ".git", "Cargo.toml" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        buildScripts = {
          enable = true,
        },
      },
      check = { command = "clippy" },
      procMacro = { enable = true },
    },
  },
})

-- LSP for Python
vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "standard",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- LSP for Vanilla HTML & CSS
vim.lsp.config("cssls", {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_markers = { "package.json", ".git" },
  settings = {
    css = { validate = true },
    scss = { validate = true },
  },
})

vim.lsp.config("html", {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  root_markers = { "package.json", ".git" },
})

vim.lsp.config("emmet_language_server", {
  cmd = { "emmet-language-server", "--stdio" },
  filetypes = { "html", "css", "javascriptreact", "typescriptreact" },
  root_markers = { "package.json", ".git" },
})

vim.lsp.enable({
  "gopls",
  "lua-language-server",
  "bash-language-server",
  "typescript-language-server",
  "astro-language-server",
  "clangd",
  "rust-analyzer",
  "cssls",
  "html",
  "emmet_language_server",
  "tailwindcss",
  "pyright",
})

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

return lsp_config
