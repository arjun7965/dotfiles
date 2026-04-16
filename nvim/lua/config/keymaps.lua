local keymap = vim.keymap

local opts = {noremap = true, silent = true}

-- Directory navigation
keymap.set("n", "<leader>m", ":NvimTreeFocus<CR>", opts)
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
keymap.set("n", "<leader>m", ":Neotree focus<CR>", opts)
keymap.set("n", "<leader>e", ":Neotree toggle<CR>", opts)

-- Search Todo
keymap.set("n", "<leader>st", ":TodoTelescope<CR>", opts)

-- Pane and Window Navigation
keymap.set("n", "<C-h>", "<C-w>h", opts) -- Navigate Left
keymap.set("n", "<C-l>", "<C-w>l", opts) -- Navigate Right
keymap.set("n", "<C-j>", "<C-w>j", opts) -- Navigate down
keymap.set("n", "<C-k>", "<C-w>k", opts) -- Navigate Up

keymap.set("t", "<C-h>", "wincmd h") -- Navigate Left
keymap.set("t", "<C-j>", "wincmd j") -- Navigate Down
keymap.set("t", "<C-k>", "wincmd k") -- Navigate Up
keymap.set("t", "<C-l>", "wincmd l") -- Navigate Right
keymap.set("n", "<C-h>", "TmuxNavigateLeft") -- Navigate Left
keymap.set("n", "<C-j>", "TmuxNavigateDown") -- Navigate Down
keymap.set("n", "<C-k>", "TmuxNavigateUp") -- Navigate Up
keymap.set("n", "<C-l>", "TmuxNavigateRight") -- Navigate Right

-- Window Management
keymap.set("n", "<leader>sv", ":vsplit<CR>", opts) -- Split Vertically
keymap.set("n", "<leader>sh", ":split<CR>", opts) -- Split Horizontally
keymap.set("n", "<C-Up>", ":resize+2<CR>", opts)
keymap.set("n", "<C-Down>", ":resize-2<CR>", opts)
keymap.set("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap.set("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- Show Full File-Path
keymap.set("n", "<leader>pa", "ShowPath") -- Show Full File Path

-- Indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- GitSigns
keymap.set("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", opts)
keymap.set("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<cr>", opts)
keymap.set("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", opts)
keymap.set("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<cr>", opts)
keymap.set("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr>", opts)

-- Invoke Lazy
keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", opts)

-- Invoke toggleterm
keymap.set("n", "<leader>t", "<cmd>ToggleTerm<cr>", opts)

