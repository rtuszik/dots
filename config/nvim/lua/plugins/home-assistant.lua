return {
    {
        "neovim/nvim-lspconfig",
        enabled = false,
        opts = {
            servers = {
                -- Define home_assistant_ls as a custom server
                home_assistant_ls = {},
            },
        },
        config = function(_, opts)
            -- Set up all servers from opts.servers
            local lspconfig = require("lspconfig")

            -- Define the custom home_assistant_ls server
            local configs = require("lspconfig.configs")
            if not configs.home_assistant_ls then
                configs.home_assistant_ls = {
                    default_config = {
                        cmd = { "home-assistant-language-server", "--stdio" },
                        filetypes = { "yaml" },
                        root_dir = lspconfig.util.root_pattern("configuration.yaml"),
                        single_file_support = false,
                        settings = {},
                    },
                    docs = {
                        description = "Language Server for Home Assistant configuration files",
                    },
                }
            end

            -- Set up the server
            lspconfig.home_assistant_ls.setup(opts.servers.home_assistant_ls or {})
        end,
    },
}
