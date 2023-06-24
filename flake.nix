{
  description = "Mini emulator for RV64IMA ISA";
   
  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:numtide/flake-utils";
  };
  
  outputs = { self, flake-compat, nixpkgs, rust-overlay, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        rust-version = "1.70.0";
        rust-dist = pkgs.rust-bin.stable.${rust-version}.default.override {
          extensions = [ "clippy" "rust-src" "rustfmt" "rust-analyzer" ];
          targets = [ "x86_64-unknown-linux-gnu" ];
        };
      in {
        devShell = pkgs.pkgsCross.riscv64-embedded.mkShell {
          # RISC-V binaries
          buildInputs = with pkgs; [ ];

          # Host architecture binaries
          nativeBuildInputs = with pkgs; [
            # Nix
            nil nixfmt
            # Rust
            cargo-msrv rust-dist
          ];

          shellHook = ''
  
          '';
  
          RUST_BACKTRACE = "1";
        };
      }
    );
  }