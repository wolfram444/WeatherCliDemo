{
  description = "Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
  
    flake-utils.lib.eachDefaultSystem (system:
  
  let
    pkgs = nixpkgs.legacyPackages.${system};
    weather_cli_demo =  pkgs.rustPlatform.buildRustPackage {
     pname = "weather_cli_demo";
     version = "0.1.0";
     src = ./.;
     cargoLock.lockFile = ./Cargo.lock;
    };

  in {
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        cargo
        rustc
        rustfmt
      ];
    };

    apps.default = {
      type = "app";
      program = "${weather_cli_demo}/bin/weather_cli_demo";
  };

  }
    );
}
