{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    devShells.${system}.default = pkgs.mkShell {
      name = "llm-devshell";

      packages = [
        pkgs.python3
        pkgs.uv

        pkgs.gnumake
        pkgs.cmake
        pkgs.pkg-config
        pkgs.gcc

        pkgs.git
        pkgs.curl
        pkgs.gnutar
        pkgs.xz
        pkgs.openssl
      ];

      shellHook = ''
        export PYTHONUNBUFFERED=1
        export UV_VENV_IN_PROJECT=1
      '';
    };
  };
}

