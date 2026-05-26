return {
    {
        "nvim-telescope/telescope.nvim",
        brach = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make"
            },
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<leader>ff", ":Telescope find_files<CR>", desc = "Buscar Archivos por Nombre", silent = true },
            { "<leader>fg", ":Telescope live_grep<CR>",  desc = "Buscar Texto en los Archivos", silent = true },
            { "<leader>fb", ":Telescope buffers<CR>",    desc = "Ver Pestañas/Buffers Abiertos", silent = true },
        },
        config = function ()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.55,
                        },
                    },

                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-c>"] = actions.close,
                        },
                    },

                    file_ignore_patterns = {
                        "node_modules/",
                        ".git/",
                        ".dist/",
                        ".astro/",
                    },
                },
            })

            telescope.load_extension("fzf")
        end,
    },
}