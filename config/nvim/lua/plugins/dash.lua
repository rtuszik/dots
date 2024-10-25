return {
    "nvimdev/dashboard-nvim",
    lazy = false, -- https://github.com/nvimdev/dashboard-nvim/pull/450
    opts = function()
        local logos = {
            [[


   ▄█   ▄█▄  ▄██████▄     ▄████████  ▄█          ▄████████  ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄   
  ███ ▄███▀ ███    ███   ███    ███ ███         ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄ 
  ███▐██▀   ███    ███   ███    ███ ███         ███    ███ ███    ███ ███▌ ███   ███   ███ 
 ▄█████▀    ███    ███   ███    ███ ███         ███    ███ ███    ███ ███▌ ███   ███   ███ 
▀▀█████▄    ███    ███ ▀███████████ ███       ▀███████████ ███    ███ ███▌ ███   ███   ███ 
  ███▐██▄   ███    ███   ███    ███ ███         ███    ███ ███    ███ ███  ███   ███   ███ 
  ███ ▀███▄ ███    ███   ███    ███ ███▌    ▄   ███    ███ ███    ███ ███  ███   ███   ███ 
  ███   ▀█▀  ▀██████▀    ███    █▀  █████▄▄██   ███    █▀   ▀██████▀  █▀    ▀█   ███   █▀  
  ▀                                 ▀                                                      
      ]],
            [[
     ██ ▄█▀ ▒█████   ▄▄▄       ██▓    ▄▄▄    ██▒   █▓ ██▓ ███▄ ▄███▓
     ██▄█▒ ▒██▒  ██▒▒████▄    ▓██▒   ▒████▄ ▓██░   █▒▓██▒▓██▒▀█▀ ██▒
    ▓███▄░ ▒██░  ██▒▒██  ▀█▄  ▒██░   ▒██  ▀█▄▓██  █▒░▒██▒▓██    ▓██░
    ▓██ █▄ ▒██   ██░░██▄▄▄▄██ ▒██░   ░██▄▄▄▄██▒██ █░░░██░▒██    ▒██ 
    ▒██▒ █▄░ ████▓▒░ ▓█   ▓██▒░██████▒▓█   ▓██▒▒▀█░  ░██░▒██▒   ░██▒
    ▒ ▒▒ ▓▒░ ▒░▒░▒░  ▒▒   ▓▒█░░ ▒░▓  ░▒▒   ▓▒█░░ ▐░  ░▓  ░ ▒░   ░  ░
    ░ ░▒ ▒░  ░ ▒ ▒░   ▒   ▒▒ ░░ ░ ▒  ░ ▒   ▒▒ ░░ ░░   ▒ ░░  ░      ░
    ░ ░░ ░ ░ ░ ░ ▒    ░   ▒     ░ ░    ░   ▒     ░░   ▒ ░░      ░   
    ░  ░       ░ ░        ░  ░    ░  ░     ░  ░   ░   ░         ░   
                                                 ░                  
      ]],
            [[
    ░  ░░░░  ░░░      ░░░░      ░░░  ░░░░░░░░░      ░░░  ░░░░  ░░        ░░  ░░░░  ░
    ▒  ▒▒▒  ▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒   ▒▒   ▒
    ▓     ▓▓▓▓▓  ▓▓▓▓  ▓▓  ▓▓▓▓  ▓▓  ▓▓▓▓▓▓▓▓  ▓▓▓▓  ▓▓▓  ▓▓  ▓▓▓▓▓▓  ▓▓▓▓▓        ▓
    █  ███  ███  ████  ██        ██  ████████        ████    ███████  █████  █  █  █
    █  ████  ███      ███  ████  ██        ██  ████  █████  █████        ██  ████  █
                                                                                    
      ]],

            [[
            /'--.._ `'-="""=-'` _..--'\
            |   ~. )  _     _  ( .~   |
            \  '~/   a  _  a   \~'  /
              \  `|     / \     |`  /
              `'--\    \_/    /--'`
                  .'._  J__.-'.
                  / /  '-/_ `-  \
                / -"-'-.  '-.__/
                \__,-.\/     | `\
                /  ;---.  .--'   |
                |     /\'-'      /
                '.___.\   _.--;'`)
      _  __           _     __     _____ __  __ 
    | |/ /___   __ _| | __ \ \   / /_ _|  \/  |
    | ' // _ \ / _` | |/ _` \ \ / / | || |\/| |
    | . \ (_) | (_| | | (_| |\ V /  | || |  | |
    |_|\_\___/ \__,_|_|\__,_| \_/  |___|_|  |_|
      ]],
        }

        math.randomseed(os.time() + vim.loop.hrtime())
        math.random()
        math.random()
        math.random()

        local neon_colors = {
            "#FF6EC7", -- Neon Pink
            "#4D4DFF", -- Neon Blue
            "#39FF14", -- Neon Green
            "#FFFF33", -- Neon Yellow
            "#CCFF00", -- Neon Lime
            "#FF00FF", -- Neon Magenta
            "#00FFFF", -- Neon Cyan
            "#FF073A", -- Neon Red
            "#BC13FE", -- Neon Purple
            "#0AFF02", -- Neon Bright Green
            "#FE4164", -- Neon Hot Pink
            "#C7FCEC", -- Neon Mint
            "#FC74FD", -- Neon Violet
            "#FFF700", -- Neon Electric Yellow
            "#E6F51D", -- Neon Chartreuse
            "#F532E5", -- Neon Fuchsia
            "#00B7EB", -- Neon Sky Blue
            "#D90166", -- Neon Raspberry
            "#FFD300", -- Neon Gold
            "#FFDF00", -- Neon Amber
            "#DAFF33", -- Neon Lime Green
            "#FF1493", -- Neon Deep Pink
            "#FDFF00", -- Neon Lemon
            "#8DFF00", -- Neon Apple Green
            "#FF004D", -- Neon Scarlet
            "#3AFEFF", -- Neon Turquoise
            "#FD01A5", -- Neon Rose
            "#A4F4F9", -- Neon Baby Blue
            "#DBFE87", -- Neon Pastel Green
            "#D5FF00", -- Neon Spring Green
            "#FF5555", -- Neon Coral
            "#E936A7", -- Neon Pink Purple
            "#FF6FFF", -- Neon Lavender
            "#1B03A3", -- Neon Indigo
            "#FFAA1D", -- Neon Orange Yellow
            "#99FE00", -- Neon Acid Green
            "#7DF9FF", -- Neon Electric Blue
            "#FF69B4", -- Neon Hot Pink
        }
        local function random_color()
            return neon_colors[math.random(1, #neon_colors)]
        end

        -- Select a random logo
        local logo = logos[math.random(1, #logos)]
        local logo_color = random_color()

        -- Apply the random color to the DashboardHeader highlight group
        vim.api.nvim_set_hl(0, "DashboardHeader", { fg = logo_color })

        -- Add padding before and after the logo
        logo = string.rep("\n", 8) .. logo .. "\n\n"

        local opts = {
            theme = "doom",
            hide = {
                statusline = false,
            },
            config = {
                header = vim.split(logo, "\n"),
                center = {
                    {
                        action = "lua LazyVim.pick()()",
                        desc = " Find File",
                        icon = " ",
                        key = "f",
                    },
                    {
                        action = "ene | startinsert",
                        desc = " New File",
                        icon = " ",
                        key = "n",
                    },
                    {
                        action = 'lua LazyVim.pick("oldfiles")()',
                        desc = " Recent Files",
                        icon = " ",
                        key = "r",
                    },
                    {
                        action = 'lua LazyVim.pick("live_grep")()',
                        desc = " Find Text",
                        icon = " ",
                        key = "g",
                    },
                    {
                        action = "lua LazyVim.pick.config_files()()",
                        desc = " Config",
                        icon = " ",
                        key = "c",
                    },
                    {
                        action = 'lua require("persistence").load()',
                        desc = " Restore Session",
                        icon = " ",
                        key = "s",
                    },
                    {
                        action = "LazyExtras",
                        desc = " Lazy Extras",
                        icon = " ",
                        key = "x",
                    },
                    {
                        action = "Lazy",
                        desc = " Lazy",
                        icon = "󰒲 ",
                        key = "l",
                    },
                    {
                        action = function()
                            vim.api.nvim_input("<cmd>qa<cr>")
                        end,
                        desc = " Quit",
                        icon = " ",
                        key = "q",
                    },
                    { desc = "Robins Neovim" },
                },
                footer = function()
                    local stats = require("lazy").stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    return {
                        "⚡ Neovim loaded "
                            .. stats.loaded
                            .. "/"
                            .. stats.count
                            .. " plugins in "
                            .. ms
                            .. "ms",
                    }
                end,
            },
        }

        for _, button in ipairs(opts.config.center) do
            button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
            button.key_format = "  %s"
        end

        -- Open dashboard after closing lazy
        if vim.o.filetype == "lazy" then
            vim.api.nvim_create_autocmd("WinClosed", {
                pattern = tostring(vim.api.nvim_get_current_win()),
                once = true,
                callback = function()
                    vim.schedule(function()
                        vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
                    end)
                end,
            })
        end

        return opts
    end,
}
