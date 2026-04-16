local config = function()
    --vim.opt.runtimepath:prepend("/shared/home/.config/nvim/parser/")
	require("nvim-treesitter.configs").setup({
		build = ":TSUpdate",
		indent = {
			enable = true,
		},
		autotag = {
			enable = false,
		},
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		ensure_installed = {
			"markdown",
			"json",
			"yaml",
			"html",
			"markdown",
			"bash",
			"lua",
			"dockerfile",
			"gitignore",
			"python",
			"cpp",
			"c",
			"csv",
			"git_config",
			"regex",
			"t32",
			"tcl",
			"tmux",
			"vim",
			"xml",
		    "verilog",
			"ssh_config",
		},
		auto_install = false,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-s>",
				node_incremental = "<C-s>",
				scope_incremental = false,
				node_decremental = "<BS>",
			},
		},
	})
end

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	config = config,
}
