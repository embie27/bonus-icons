{
  description = "A very basic flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, flake-utils, nixpkgs }: 

    flake-utils.lib.eachDefaultSystem (system:

      let 
        pkgs = import nixpkgs { inherit system; };
      in rec {
        packages.bonus-icons = pkgs.stdenv.mkDerivation {
          name = "bonus-icons";
          src = ./.;
          nativeBuildInputs = with pkgs; [
            (python3.withPackages (pypkgs: with pypkgs; [ fontforge ]))
          ];

          buildPhase = ''
            python make-font.py
          '';
          installPhase = ''
            install -m444 -Dt $out/share/fonts/truetype bonus-icons.ttf
          '';
        };

        defaultPackage = packages.bonus-icons;
      }
    );
}
