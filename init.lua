require("core.options")
require("core.lazy")

if vim.fn.argc(-1) == 0 then
  local group = vim.api.nvim_create_augroup("vimrc", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "VeryLazy",
    callback = function()
      require("core.autocmds")
      require("core.keymaps")
    end,
  })
else
  require("core.autocmds")
  require("core.keymaps")
end
