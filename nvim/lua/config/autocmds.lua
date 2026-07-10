vim.api.nvim_create_autocmd("VimEnter", {
  desc = "",
  callback = function()
    local first_arg = vim.fn.argv(0)
    if first_arg ~= "" and vim.fn.isdirectory(first_arg) == 1 then
      local target_buf = vim.api.nvim_get_current_buf()

      vim.cmd("cd " .. vim.fn.fnameescape(first_arg))

      require("snacks").dashboard.open()

      vim.api.nvim_buf_delete(target_buf, { force = true })
    end
  end,
})
