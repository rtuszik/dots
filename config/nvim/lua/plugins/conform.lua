return {
    "stevearc/conform.nvim",
    lazy = true,
    opts = function()
        local opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
            },
        }
        return opts
    end,
}
