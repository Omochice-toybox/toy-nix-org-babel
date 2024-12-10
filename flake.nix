{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    org-babel.url = "github:emacs-twist/org-babel";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      nixpkgs,
      org-babel,
      flake-parts,
      ...
    }:
    let
      tangle = org-babel.lib.tangleOrgBabel {
        languages = [
          "emacs-lisp"
          "ruby"
        ];
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        systems = nixpkgs.lib.platforms.all;
        perSystem =
          { pkgs, ... }:
          {
            apps = {
              default = {
                type = "app";
                program = pkgs.writeShellScriptBin "tangle" ''
                  cat <<EOF> hoge.rb
                  ${tangle (builtins.readFile ./config.org)}
                  EOF
                '';
              };
            };
          };

      };
}
