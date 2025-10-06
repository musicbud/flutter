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
  ];

  shellHook = ''
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
      pkgs.gtk3
      pkgs.vulkan-loader
    ]}"
    export CHROME_EXECUTABLE=${pkgs.chromium}/bin/chromium
  '';
}
