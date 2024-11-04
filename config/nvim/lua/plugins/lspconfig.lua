return {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
        ---@type lspconfig.options
        servers = {
            pyright = {
                settings = {
                    pyright = {
                        -- Using Ruff's import organizer
                        disableOrganizeImports = true,
                    },
                    python = {
                        analysis = {
                            -- Ignore all files for analysis to exclusively use Ruff for linting
                            ignore = { "*" },
                        },
                    },
                },
            },
            -- ruff = {
            --   init_options = {
            --     settings = {
            --       -- Any Ruff-specific settings can go here
            --     },
            --   },
            -- },
        },
        setup = {
            ruff = function(_, opts)
                opts.on_attach = function(client, _)
                    -- Disable hover in favor of Pyright
                    client.server_capabilities.hoverProvider = false
                end
            end,
        },
    },
}
