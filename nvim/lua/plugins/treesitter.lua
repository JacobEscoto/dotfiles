return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function ()
            require("nvim-treesitter").setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            require("nvim-treesitter").install({
                "html",
                "css",
                "javascript",
                "typescript",
                "tsx",
                "astro",
                "lua",
                "json",
                "bash",
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function(args)
                  local buf = args.buf
                  local ft = vim.bo[buf].filetype

                  local lang = vim.treesitter.language.get_lang(ft)
                  if not lang then
                    return
                  end

                  local ok_add = pcall(vim.treesitter.language.add, lang)
                  if not ok_add then
                    return
                  end
                    pcall(vim.treesitter.start, buf, lang)
                end,
            })
        end,
    },
}
