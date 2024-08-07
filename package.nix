{ fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, lib
, flutter
, gnome
, quickemu
}:
let
  runtimeBinDependencies = [ quickemu gnome.zenity ];
  versionMatches = builtins.match ''
    .*
    .*version:[[:blank:]]([[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\+?[[:digit:]]*)
    .*
  '' (builtins.readFile ./pubspec.yaml);
in
flutter.buildFlutterApplication rec {
  pname = "quickgui";
  version = builtins.concatStringsSep "" versionMatches;
  src = lib.cleanSource ./.;
  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    window_size = "sha256-XelNtp7tpZ91QCEcvewVphNUtgQX7xrp5QP0oFo6DgM=";
  };

  # These things are added to LD_LIBRARY_PATH, but not PATH
  extraWrapProgramArgs = "--prefix PATH : ${lib.makeBinPath runtimeBinDependencies}";

  nativeBuildInputs = [ copyDesktopItems ];

  postFixup = ''
    for SIZE in 16 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/$SIZEx$SIZE/apps/
      cp -av assets/resources/quickgui_$SIZE.png $out/share/icons/hicolor/$SIZEx$SIZE/apps/quickgui.png
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "quickgui";
      exec = "quickgui";
      icon = "quickgui";
      desktopName = "Quickgui";
      comment = "An elegant virtual machine manager for the desktop";
      categories = [ "Development" "System" ];
    })
  ];

  meta = with lib; {
    description = "An elegant virtual machine manager for the desktop";
    homepage = "https://github.com/quickemu-project/quickgui";
    changelog = "https://github.com/quickemu-project/quickgui/releases/";
    license = licenses.mit;
    maintainers = with maintainers; [ flexiondotorg heyimnova ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "quickgui";
  };
}
