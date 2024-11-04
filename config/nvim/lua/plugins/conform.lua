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
                html = { "prettier", "djlint" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
            },
            formatters = {
                prettier = {
                    prepend_args = { "--tab-width", "4", "--print-width", "100" },
                },
                ruff = {},
            },
        }
        return opts
    end,
}
