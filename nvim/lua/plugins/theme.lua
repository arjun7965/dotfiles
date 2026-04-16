-- return {
--     "EdenEast/nightfox.nvim",
--     lazy = false,
--     priority = 999,
--     config = function()
--     vim.cmd('colorscheme nightfox')
--     end
-- }

return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
    require("catppuccin").setup({
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
            comments = {}, -- Change the style of comments
            conditionals = {},
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
            -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        custom_highlights = {},
    })
    vim.cmd('colorscheme catppuccin')
    end,
}

-- return {
--     "folke/tokyonight.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--     vim.cmd('colorscheme tokyonight')
--     end,
--     opts = {},
-- }
