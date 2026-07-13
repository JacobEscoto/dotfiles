return {
  {
    "olimorris/persisted.nvim",
    event = "VimEnter",
    priority = 1,
    opts = {
      save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
      follow_cwd = true,
      use_git_branch = false,
      autoload = false, -- Automatically load the session for the cwd on Neovim startup?

      allowed_dirs = {
        "~/dotfiles",
        "~/projects",
      },

      ignored_dirs = {
        "~/.config",
        "~/.local",
      },
    },

    config = function(_, opts)
      require("persisted").setup(opts)

      local function decode_session_path(path)
        local filename = path:match("([^/]+)$")

        filename = filename:gsub("%.vim$", "")

        local decoded = filename:gsub("%%", "/")
        return decoded
      end

      local function session_picker()
        local sessions = require("persisted").list()
        if vim.tbl_isempty(sessions) then
          vim.notify("No saved sessions", vim.log.levels.INFO)
          return
        end

        local choices = {}
        local session_map = {}

        for _, session_path in ipairs(sessions) do
          local decoded = decode_session_path(session_path)
          local label = decoded:match("([^/]+/[^/]+)$") or decoded

          table.insert(choices, label)
          session_map[label] = session_path
        end

        vim.ui.select(choices, {
          prompt = "Restore Session: ",
        }, function(choice)
          if choice then
            require("persisted").load({ session = session_map[choice] })
          end
        end)
      end

      _G.PersistedSnacksPicker = session_picker

      vim.keymap.set("n", "<leader>rs", session_picker, { desc = "Restore session" })
      vim.keymap.set("n", "<leader>ws", function()
        require("persisted").save()
        vim.notify("Session saved", vim.log.levels.INFO)
      end, { desc = "Write session" })
    end,
  },
}
