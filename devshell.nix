# https://manuelplavsic.ch/articles/flutter-environment-with-nix/
{
  lib,
  mkShell,
  pkgs,
  stdenv,
  appimagekit,
  clang,
  cmake,
  dart,
  dpkg,
  flutter,
  git,
  gnome,
  gtk3,
  ninja,
  patchelf,
  pcre2,
  plocate,
  pkg-config,
  quickemu,
  rpm,
}:
mkShell rec {
  FLUTTER_ROOT = flutter;
  DART_ROOT = "${flutter}/bin/cache/dart-sdk";
  buildInputs = [
    appimagekit
    clang
    cmake
    dart
    dpkg
    flutter
    git
    gnome.zenity
    gtk3
    ninja
    patchelf
    pcre2
    plocate
    pkg-config
    quickemu
    rpm
  ];
  # vulkan-loader and libGL shared libs are necessary for hardware decoding
  LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [ pkgs.vulkan-loader pkgs.libGL ]}";
  # Packages installed via `dart pub global activate package_name` are
  # located in the `$PUB_CACHE/bin` directory.
  shellHook = ''
    if [ -z "$PUB_CACHE" ]; then
      export PATH="$PATH":"$HOME/.pub-cache/bin"
    else
      export PATH="$PATH":"$PUB_CACHE/bin"
    fi
  '';
}
