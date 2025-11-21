set shell := ["bash", "-euo", "pipefail", "-c"]

flake := justfile_directory()
system := `nix eval --impure --raw --expr builtins.currentSystem`

build:
	nix build "{{flake}}#packages.{{system}}.default"

dev:
	nix develop "{{flake}}" -c "$SHELL"

# Prefer your custom runner: `nix run .#build-switch [args…]`
# Pass any extra args like: just switch -- host=beast  (or whatever your app expects)
switch *ARGS:
	nix run "{{flake}}#build-switch" -- {{ARGS}} || \
	(command -v darwin-rebuild >/dev/null && darwin-rebuild switch --flake "{{flake}}") || \
	(command -v home-manager >/dev/null && home-manager switch --flake "{{flake}}") || \
	(command -v nixos-rebuild >/dev/null && sudo nixos-rebuild switch --flake "{{flake}}") || \
	echo "No switch tool or app found."

update:
	nix flake update

upgrade-all:
	just update
	just switch
	just build
