{
  description = "A Nix-flake-based Node.js development environment";

  # GitHub URLs for the Nix inputs we're using
  inputs = {
    # Simply the greatest package repository on the planet
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # A set of helper functions for using flakes
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils}:
    flake-utils.lib.eachDefaultSystem (system:
      let
        #overlays = [
        #  (final: prev: rec {
        #    pnpm = prev.nodePackages.pnpm;
        #  })
        #];
        # System-specific nixpkgs with rust-overlay applied
        pkgs = import nixpkgs {
          inherit system; # overlays;
          # config = { allowUnfree = true; };
        };



      in {
        devShells = {
          default = pkgs.mkShell {
            # programs and libraries used by the new derivation at run-time
            buildInputs = with pkgs; [

              # core
              nodejs_22
              nodejs_22.pkgs.pnpm

              # tools
              just

            ];
            # programs and libraries used at build-time that, 
            # if they are a compiler or similar tool, produce code to run 
            # at run-time—i.e. tools used to build the new derivation
            nativeBuildInputs = [ ];

            # Run when the shell is started up
            shellHook = ''
              echo "just version: $just_version"
              ssh_version=$(which ssh)
              pnpm_version=$(pnpm --version)
              echo "pnpm version: $pnpm_version"
              pnpm install
              # pnpm exec husky install
            '';
          };
        };
      });
}
