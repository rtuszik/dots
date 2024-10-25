return {
    "antonk52/bad-practices.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
        require("bad_practices").setup({
            most_splits = 3,
            most_tabs = 3,
            max_hjkl = 10,
        })
    end,
}
