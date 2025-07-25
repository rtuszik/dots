return {
    "williamboman/mason.nvim",
    opts = {
        ensure_installed = {
            "stylua",
            "shellcheck",
            "shfmt",
            "flake8",
            "prettier",
            "ruff",
            "djlint",
            "terraform",
            "rustfmt",
            "rust-analyzer",
            "clangd",
            "clang-format",
        },
    },
}
