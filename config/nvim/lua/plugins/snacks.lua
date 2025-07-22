return {
    "folke/snacks.nvim",
    enabled = true,
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = { enabled = true },
        dashboard = {
            enabled = true,
            row = nil, -- keeps auto-centering
            col = nil, -- keeps auto-centering
            pane_gap = 8, -- reduce gap between panes
            -- width = 120, -- set explicit total width

            preset = {
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    {
                        icon = " ",
                        key = "c",
                        desc = "Config",
                        action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
                    },
                    { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                },
                header = [[
     ██ ▄█▀ ▒█████   ▄▄▄       ██▓    ▄▄▄    ██▒   █▓ ██▓ ███▄ ▄███▓
     ██▄█▒ ▒██▒  ██▒▒████▄    ▓██▒   ▒████▄ ▓██░   █▒▓██▒▓██▒▀█▀ ██▒
    ▓███▄░ ▒██░  ██▒▒██  ▀█▄  ▒██░   ▒██  ▀█▄▓██  █▒░▒██▒▓██    ▓██░
    ▓██ █▄ ▒██   ██░░██▄▄▄▄██ ▒██░   ░██▄▄▄▄██▒██ █░░░██░▒██    ▒██ 
    ▒██▒ █▄░ ████▓▒░ ▓█   ▓██▒░██████▒▓█   ▓██▒▒▀█░  ░██░▒██▒   ░██▒
    ▒ ▒▒ ▓▒░ ▒░▒░▒░  ▒▒   ▓▒█░░ ▒░▓  ░▒▒   ▓▒█░░ ▐░  ░▓  ░ ▒░   ░  ░
    ░ ░▒ ▒░  ░ ▒ ▒░   ▒   ▒▒ ░░ ░ ▒  ░ ▒   ▒▒ ░░ ░░   ▒ ░░  ░      ░
    ░ ░░ ░ ░ ░ ░ ▒    ░   ▒     ░ ░    ░   ▒     ░░   ▒ ░░      ░   
    ░  ░       ░ ░        ░  ░    ░  ░  ░     ░  ░   ░   ░         ░   
                                                 ░                  
      ]],
            },
            sections = {
                { section = "header", padding = { 1, 20 } }, -- Add top padding to prevent upward shift
                { section = "keys", gap = 1, padding = 1 },
                -- GitHub Notifications in pane 1 (always shown)
                {
                    pane = 1,
                    section = "terminal",
                    title = "Notifications",
                    cmd = "gh notify -s -a -n5",
                    action = function()
                        vim.ui.open("https://github.com/notifications")
                    end,
                    key = "n",
                    icon = " ",
                    height = 5,
                    enabled = true,
                    padding = 1,
                    ttl = 5 * 60,
                    indent = 3,
                },
                -- Pane 2 content
                {
                    section = "terminal",
                    cmd = "ascii-image-converter ~/.config/nvim/koalavim.png -C -c",
                    random = 10,
                    pane = 2,
                    indent = 6,
                    height = 20,
                },
                function()
                    local in_git = Snacks.git.get_root() ~= nil
                    if in_git then
                        return {
                            pane = 2,
                            icon = " ",
                            desc = "Browse Repo",
                            padding = 1,
                            key = "b",
                            action = function()
                                Snacks.gitbrowse()
                            end,
                        }
                    end
                end,
                -- Rest of GitHub items in pane 2
                function()
                    local in_git = Snacks.git.get_root() ~= nil
                    local cmds = {
                        {
                            title = "Open Issues",
                            cmd = "gh issue list -L 3",
                            key = "i",
                            action = function()
                                vim.fn.jobstart("gh issue list --web", { detach = true })
                            end,
                            icon = " ",
                            height = 7,
                        },
                        {
                            icon = " ",
                            title = "Open PRs",
                            cmd = "gh pr list -L 3",
                            key = "P",
                            action = function()
                                vim.fn.jobstart("gh pr list --web", { detach = true })
                            end,
                            height = 7,
                        },
                        {
                            icon = " ",
                            title = "Git Status",
                            cmd = "git --no-pager diff --stat -B -M -C",
                            height = 10,
                        },
                    }
                    return vim.tbl_map(function(cmd)
                        return vim.tbl_extend("force", {
                            pane = 2,
                            section = "terminal",
                            enabled = in_git,
                            padding = 1,
                            ttl = 5 * 60,
                            indent = 3,
                        }, cmd)
                    end, cmds)
                end,
            },
        },

        explorer = { enabled = false },
        image = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true, matcher = {
            frecency = true,
        } },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
    },
    config = function(_, opts)
        require("snacks").setup(opts)
        vim.ui.select = require("snacks").picker.select
    end,
}
