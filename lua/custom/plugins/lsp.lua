-- plugins/lsp.lua
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    -- 1) Diagnostics UI (unchanged)
    vim.diagnostic.config {
      underline = true,
      update_in_insert = false,
      virtual_text = { spacing = 2, source = 'if_many' },
      float = { border = 'rounded', source = 'always' },
      severity_sort = true,
    }
    for type, icon in pairs { Error = '✘', Warn = '▲', Hint = '⚑', Info = '' } do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end

    -- 2) Capabilities for nvim-cmp: set as GLOBAL DEFAULTS via "*" (new API)
    --    Docs: :help lsp-config-merge  (global "*" gets merged into every server)
    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    -- 3) Per-server adjustments with vim.lsp.config('name', {...})
    --    Example: lua_ls tweaks for Neovim runtime
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          diagnostics = { globals = { 'vim' } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    })

    -- 4) Keymaps & format-on-save on LspAttach (NOT on_attach fields)
    local grp = vim.api.nvim_create_augroup('user.lsp', { clear = true })
    vim.api.nvim_create_autocmd('LspAttach', {
      group = grp,
      callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Core navigation/actions (only if supported)
        map('n', 'gd', vim.lsp.buf.definition, 'LSP: Definition')
        map('n', 'gD', vim.lsp.buf.declaration, 'LSP: Declaration')
        map('n', 'gi', vim.lsp.buf.implementation, 'LSP: Implementation')
        map('n', 'gr', vim.lsp.buf.references, 'LSP: References')
        map('n', 'K', vim.lsp.buf.hover, 'LSP: Hover')
        map('n', '<leader>rn', vim.lsp.buf.rename, 'LSP: Rename')
        map('n', '<leader>ca', vim.lsp.buf.code_action, 'LSP: Code Action')
        map('n', '<leader>ds', vim.lsp.buf.document_symbol, 'LSP: Document Symbols')
        map('n', '<leader>ws', vim.lsp.buf.workspace_symbol, 'LSP: Workspace Symbols')
        map('n', '<leader>f', function()
          vim.lsp.buf.format { async = false }
        end, 'LSP: Format')

        map('n', ']d', vim.diagnostic.goto_next, 'Diag: Next')
        map('n', '[d', vim.diagnostic.goto_prev, 'Diag: Prev')
        map('n', '<leader>e', vim.diagnostic.open_float, 'Diag: Float')
        map('n', '<leader>q', vim.diagnostic.setloclist, 'Diag: Loclist')

        -- Optional: format on save (use server capability checks)
        if client and client:supports_method 'textDocument/formatting' and not client:supports_method 'textDocument/willSaveWaitUntil' then
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = grp,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false, bufnr = bufnr, id = client.id }
            end,
          })
        end
      end,
    })

    -- 5) Enabling servers:
    -- We rely on mason-lspconfig's automatic_enable to call vim.lsp.enable()
    -- for installed servers. You may also enable manually, e.g.:
    --   vim.lsp.enable('pyright')
    --   vim.lsp.enable('ts_ls')
    -- Docs / examples: :help lsp-quickstart
  end,
}
