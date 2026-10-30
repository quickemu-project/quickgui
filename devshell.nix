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
  zenity,
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
    zenity
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
    flutter pub get
    yq eval pubspec.lock -o=json -P > pubspec.lock.json
    flutter config --enable-linux-desktop
    dart pub global activate fastforge 0.6.12
    echo "**********************************************************************"
    echo "* flutter build linux --release                                      *"
    echo "* fastforge package --platform=linux --targets=zip                  *"
    echo "**********************************************************************"
    if [ -z "$PUB_CACHE" ]; then
      export PATH="$PATH":"$HOME/.pub-cache/bin"
    else
      export PATH="$PATH":"$PUB_CACHE/bin"
    fi
  '';
}
