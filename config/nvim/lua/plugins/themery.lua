return {
    "zaldih/themery.nvim",
    config = function()
        -- Minimal config
        require("themery").setup({
            themes = { "catppuccin", "cyberdream", "mellow", "oxocarbon" }, -- Your list of installed colorschemes.
            livePreview = true, -- Apply theme while picking. Default to true.
        })
    end,
}
