#!/usr/bin/env bash

# Set up library paths for NixOS Flutter development
export PKG_CONFIG_PATH="$(nix eval --raw nixpkgs#libepoxy.dev)/lib/pkgconfig:$PKG_CONFIG_PATH"
export LD_LIBRARY_PATH="$(nix eval --raw nixpkgs#fontconfig)/lib:$(nix eval --raw nixpkgs#libepoxy)/lib:$(nix eval --raw nixpkgs#gtk3)/lib:$(nix eval --raw nixpkgs#glib)/lib:$LD_LIBRARY_PATH"

flutter run -d linux --debug
