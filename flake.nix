# flake.nix, run with `nix develop`
{
  description = "Ollama CUDA development environment";
  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.cudaSupport = true;
      config.cudaVersion = "12";
    };
    # Change according to the driver used: stable, beta
    nvidiaPackage = pkgs.linuxPackages.nvidiaPackages.stable;

    # Ollama
    ollama-cuda = pkgs.ollama.override {
      acceleration = "cuda";
    };

  in {
    # alejandra is a nix formatter with a beautiful output
    formatter."${system}" = nixpkgs.legacyPackages.${system}.alejandra;
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        ffmpeg
        fmt.dev
        cudaPackages.cuda_cudart
        cudatoolkit
        nvidiaPackage
        cudaPackages.cudnn
        libGLU
        libGL
        libxi
        libxmu
        freeglut
        libxext
        libx11
        libxv
        libxrandr
        zlib
        ncurses
        stdenv.cc
        binutils
        uv
        python3
        ollama-cuda
      ];

      shellHook = ''
        export LD_LIBRARY_PATH="${nvidiaPackage}/lib:$LD_LIBRARY_PATH"
        export CUDA_PATH=${pkgs.cudatoolkit}
        export EXTRA_LDFLAGS="-L/lib -L${nvidiaPackage}/lib"
        export EXTRA_CCFLAGS="-I/usr/include"
        export CMAKE_PREFIX_PATH="${pkgs.fmt.dev}:$CMAKE_PREFIX_PATH"
        export PKG_CONFIG_PATH="${pkgs.fmt.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"

        exec fish
      '';
    };
  };
}
