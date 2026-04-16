-- local config = function ()
--     require("bufferline").setup({
--         options = {
--             mode = "tabs", -- set to "tabs" to only show tabpages instead
--             style_preset = require("bufferline").style_preset.minimal, -- or bufferline.style_preset.default,
--             themable = false, -- allows highlight groups to be overriden i.e. sets highlights as default
--             buffer_close_icon = '󰅖',
--             modified_icon = '●',
--             close_icon = '',
--             left_trunc_marker = '',
--             right_trunc_marker = '',
--         },
--     })
-- end

-- return {
--     'akinsho/bufferline.nvim',
--     version = "*",
--     event = "VeryLazy",
--     dependencies = 'nvim-tree/nvim-web-devicons',
--     config = config,
-- }

return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons'
}

--return {
--  "akinsho/bufferline.nvim",
--  keys = {
--    {
--      "<S-Right>",
--      function()
--        vim.cmd("bnext " .. vim.v.count1)
--      end,
--      desc = "Next buffer",
--    },
--    {
--      "<S-Left>",
--      function()
--        vim.cmd("bprev " .. vim.v.count1)
--      end,
--      desc = "Previous buffer",
--    },
--    { "<leader><CR>", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Close Unpinned Buffers" },
--  },
--}
