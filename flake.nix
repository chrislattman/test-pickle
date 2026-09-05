{
  description = "Reproducible six-language development environment";

  inputs = {
    # This branch is resolved to an exact nixpkgs commit in flake.lock.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Used to obtain an exact Rust toolchain version.
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          rust-overlay.overlays.default
        ];
      };

      rustToolchain =
        pkgs.rust-bin.stable."1.98.1".minimal;

    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          # General
          git
          curl
          pkg-config

          # Java
          jdk25

          # C / C++
          gcc
          gnumake
          cmake

          # Python
          python3

          # Node.js + npm
          nodejs

          # Go
          go

          # Rust
          rustToolchain
        ];

        # Prevent modern Go from downloading a different toolchain.
        GOTOOLCHAIN = "local";

        shellHook = ''
          # ------------------------------------------------------------
          # Python + Conan
          # ------------------------------------------------------------

          if [ ! -d .venv ]; then
              python3 -m venv .venv
          fi

          source .venv/bin/activate

          python -m pip install conan

          echo "------------------------------------"

          java -version 2>&1 | head -n 1
          gcc --version | head -n 1
          cmake --version | head -n 1
          python --version
          conan --version
          node --version
          npm --version
          go version
          rustc --version
          cargo --version
          echo
        '';
      };
    };
}
