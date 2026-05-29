return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>a", function ()
        require("harpoon"):list():add()
        vim.notify("harpooned file", vim.log.levels.INFO)
      end, desc = "Harpoon: Mark File" },

      { "<C-e>", function ()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, desc = "Harpoon: View menu" },

      { "<A-1>", function() require("harpoon"):list():select(1) end, desc = "Harpoon: File 1" },
      { "<A-2>", function() require("harpoon"):list():select(2) end, desc = "Harpoon: File 2" },
      { "<A-3>", function() require("harpoon"):list():select(3) end, desc = "Harpoon: File 3" },
      { "<A-4>", function() require("harpoon"):list():select(4) end, desc = "Harpoon: File 4" },
    },
    config = function()
      local harpoon = require("harpoon")
      harpoon.setup({
        settings = {
          save_on_toggle = true,
        },
      })
    end,
  },
}
