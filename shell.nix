{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    clang
    cmake
    ninja
    pkg-config
    gtk3
    gtk3.dev
    xz
    flutter
    pcre
    pcre.dev
    glib
    glib.dev
    libepoxy
    libepoxy.dev
    vulkan-headers
    vulkan-loader
    vulkan-tools
    chromium
    libsecret
    libsecret.dev  # Development headers for flutter_secure_storage
    libsysprof-capture  # Sysprof capture library
    sysprof  # System profiler
    pcre2.dev  # PCRE2 development headers for GLib
    util-linux.dev  # Provides mount.pc for gio-2.0
  ];

  shellHook = ''
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
      pkgs.gtk3
      pkgs.vulkan-loader
    ]}"
    export CHROME_EXECUTABLE=${pkgs.chromium}/bin/chromium
    export PKG_CONFIG_PATH="/run/current-system/sw/lib/pkgconfig:$PKG_CONFIG_PATH"
    export CXXFLAGS="-Wno-error=deprecated-literal-operator $CXXFLAGS"
    export CFLAGS="-Wno-error=deprecated-literal-operator $CFLAGS"
    echo "Flutter development environment loaded with system libraries"
    pkg-config --modversion libsecret-1 2>/dev/null && echo "✓ libsecret-1 available" || echo "✗ libsecret-1 not found"
    pkg-config --modversion sysprof-capture-4 2>/dev/null && echo "✓ sysprof-capture-4 available" || echo "✗ sysprof-capture-4 not found"
    pkg-config --modversion libpcre2-8 2>/dev/null && echo "✓ libpcre2-8 available" || echo "✗ libpcre2-8 not found"
  '';
}
