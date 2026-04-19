return {
    "goolord/alpha-nvim",
    config = function(_, opts)
        local dashboard = require("alpha.themes.dashboard")
        local logo = [[
            ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
            ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
            ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
            ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
            ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
            ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
                            [ -Arjun Vinod ]
        ]]


        vim.split(logo, "\n", { trimempty = true })
        dashboard.section.header.val = logo
        -- Set menu
        dashboard.section.buttons.val = {
            dashboard.button( "a", "  > New File" , ":ene <BAR> startinsert <CR>"),
            dashboard.button( "f", "  > Find file", ":cd $HOME/Workspace | Telescope find_files<CR>"),
            dashboard.button( "r", "  > Recent"   , ":Telescope oldfiles<CR>"),
            dashboard.button( "s", "  > Settings" , ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
            dashboard.button( "l", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"),
            dashboard.button( "q", "  > Quit NVIM", ":qa<CR>"),
        }
        require("alpha").setup(dashboard.opts)
    end,
    lazy = false,
    priority = 999,
}

-- startify-nvim theme
-- return {
--     "goolord/alpha-nvim",
--     dependencies = { 'nvim-tree/nvim-web-devicons' },
--     config = function ()
--         require'alpha'.setup(require'alpha.themes.startify'.config)
--     end
-- }

-- dashboard-nvim theme
-- return {
--     'goolord/alpha-nvim',
--     lazy = false,
--     priority = 1000,
--     config = function ()
--         require'alpha'.setup(require'alpha.themes.dashboard'.config)
--     end
-- }


-- theta theme
-- return {
--     'goolord/alpha-nvim',
--     dependencies = {
--         'nvim-tree/nvim-web-devicons',
--         'nvim-lua/plenary.nvim'
--     },
--     config = function ()
--         require'alpha'.setup(require'alpha.themes.theta'.config)
--     end
-- };
