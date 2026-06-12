return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      open_mapping = nil, -- we control keymaps ourselves
      shade_terminals = true,
      start_in_insert = true,
      persist_size = true,
      direction = "float",
      float_opts = {
        border = "rounded",
      },
    })
  end,
}
