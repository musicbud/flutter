{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSEnv {
  name = "flutter-env";
  
  targetPkgs = pkgs: (with pkgs; [
    # Flutter and Dart
    flutter
    
    # Build tools
    pkg-config
    cmake
    ninja
    clang
    
    # GTK and GNOME dependencies
    gtk3
    glib
    gdk-pixbuf
    cairo
    pango
    atk
    at-spi2-atk
    at-spi2-core
    dbus
    
    # Graphics and rendering
    libGL
    mesa
    
    # Fonts and text rendering
    freetype
    fontconfig
    harfbuzz
    
    # X11 and Wayland
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXrandr
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXfixes
    libxkbcommon
    wayland
    
    # Other libraries
    zlib
    libepoxy
    libsecret
    
    # System libraries
    glibc
    stdenv.cc.cc.lib
  ]);
  
  multiPkgs = pkgs: (with pkgs; [
    # Add any multi-arch dependencies here if needed
  ]);
  
  runScript = "bash";
  
  profile = ''
    export LD_LIBRARY_PATH=/usr/lib:/usr/lib64
    export FLUTTER_ROOT="${pkgs.flutter}"
  '';
}).env
