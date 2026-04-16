return {
	"williamboman/mason.nvim",
	cmd = "Mason",
	--event = "BufReadPre",
	opts = {
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
        registries = {
            -- "/shared/home/avinod/src/mason-registry",
            "github:mason-org/mason-registry"
        },
	},
}
