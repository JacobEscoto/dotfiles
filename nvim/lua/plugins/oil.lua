return {
  {
    "stevearc/oil.nvim",

    -- Load Oil when opening a directory or when using the keymap
    lazy = false,

    opts = {
      default_file_explorer = false,
      restore_win_options = false,
      skip_confirm_for_simple_edits = false,
      prompt_save_on_select_new_entry = true,

      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },

      keymaps = {
        -- Help
        ["g?"] = "actions.show_help",

        -- Selection and navigation
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open in vertical split" },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open in horizontal split" },
        ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open in new tab" },
        ["<C-p>"] = "actions.preview",

        ["<BS>"] = "actions.parent",
        ["^"] = "actions.root_dir",

        -- Create and modify
        ["g."] = "actions.toggle_hidden",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",

        -- Create file
        ["<leader>n"] = {
          callback = function()
            require("oil").open_float()
          end,
          desc = "Toggle Oil float",
        },

        -- Copy path
        ["y."] = {
          callback = function()
            require("oil.actions").copy_entry_path.callback()
          end,
          desc = "Copy file path",
        },

        -- Rename inline
        ["r"] = "actions.rename",

        -- Delete
        ["d"] = "actions.delete",

        -- Create new file
        ["a"] = "actions.create",
      },

      view_options = {
        -- Show files and directories that start with "." by default
        show_hidden = true,

        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, ".")
        end,

        is_always_hidden = function(name, bufnr)
          return name == ".." or name == ".git" or name == "node_modules" or name == ".cache"
        end,

        natural_order = true,
        case_insensitive = false,
        sort = {
          { "type", "asc" },
          { "name", "asc" },
        },
      },

      float = {
        padding = 2,
        max_width = 100,
        max_height = 30,
        border = "rounded",
        win_options = {
          winblend = 10,
        },

        preview_split = "auto",

        override = function(conf)
          return conf
        end,
      },

      use_trash = true,
    },

    keys = {
      -- Open oil in parent directory
      { "-", "<CMD>Oil<CR>", desc = "Open Oil (parent dir)" },

      -- Open floating Oil
      { "<leader>E", "<CMD>Oil --float<CR>", desc = "Open Oil (floating)" },

      -- Open Oil in current directory
      { "<leader>e", "<CMD>Oil<CR>", "Open Oil (current)" },
    },

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
}
