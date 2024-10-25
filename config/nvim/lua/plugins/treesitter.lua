return {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, {
            "tsx",
            "typescript",
            "bash",
            "javascript",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "regex",
            "vim",
            "yaml",
            "html",
        })
    end,
}
