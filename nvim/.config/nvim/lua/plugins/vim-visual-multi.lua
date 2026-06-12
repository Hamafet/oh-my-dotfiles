return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      vim.g.VM_default_mappings = 1
      -- ví dụ custom map:
      -- vim.g.VM_maps = {
      --   ["Find Under"] = "<C-n>",
      --   ["Find Subword Under"] = "<C-n>",
      -- }
    end,
  },
}
