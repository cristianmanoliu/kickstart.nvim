-- plugins/mason.lua
return {
  'mason-org/mason.nvim',
  build = ':MasonUpdate',
  config = function()
    require('mason').setup {
      ui = { border = 'rounded' },
    }
  end,
}
