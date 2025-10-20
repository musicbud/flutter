{
  description = "Flutter development environment with Linux desktop support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Flutter and Dart
            flutter
            
            # Core build tools
            pkg-config
            cmake
            ninja
            clang
            gcc
            stdenv.cc
            stdenv.cc.libc
            
            # GTK and desktop development
            gtk3
            glib
            gdk-pixbuf
            cairo
            pango
            atk
            at-spi2-atk
            
            # Additional Linux desktop dependencies
            xorg.libX11
            xorg.libXext
            xorg.libXi
            xorg.libXrandr
            xorg.libXcursor
            xorg.libXinerama
            xorg.libXfixes
            libGL
            libxkbcommon
            wayland
            
            # Libraries
            zlib
            freetype
            fontconfig
            libepoxy
            libsecret
            harfbuzz
            glibc
            glibc.dev
            
            # Development utilities
            git
            curl
            unzip
            which
            
            # Optional but useful
            # android-studio # Commented out due to unfree license
          ];

          shellHook = ''
            echo "Flutter development environment loaded!"
            echo "Available tools:"
            echo "  - pkg-config: $(pkg-config --version)"
            echo "  - cmake: $(cmake --version | head -1)"
            echo "  - ninja: $(ninja --version)"
            echo "  - clang: $(clang --version | head -1)"
            echo ""
            echo "To enable Linux desktop support, run:"
            echo "  flutter config --enable-linux-desktop"
            echo ""
            echo "Then test with:"
            echo "  flutter doctor"
          '';

          # Environment variables for development
          FLUTTER_ROOT = "${pkgs.flutter}";
          CHROME_EXECUTABLE = "${pkgs.chromium}/bin/chromium";
          
          # GTK and GLib paths
          PKG_CONFIG_PATH = "${pkgs.gtk3.dev}/lib/pkgconfig:${pkgs.glib.dev}/lib/pkgconfig:${pkgs.libxkbcommon.dev}/lib/pkgconfig";
          LD_LIBRARY_PATH = "${pkgs.gtk3}/lib:${pkgs.glib}/lib:${pkgs.libGL}/lib:${pkgs.libxkbcommon}/lib:${pkgs.zlib}/lib:${pkgs.freetype}/lib:${pkgs.fontconfig.lib}/lib:${pkgs.cairo}/lib:${pkgs.pango}/lib";
          C_INCLUDE_PATH = "${pkgs.glibc.dev}/include";
          CPLUS_INCLUDE_PATH = "${pkgs.glibc.dev}/include";
        };
      });
}