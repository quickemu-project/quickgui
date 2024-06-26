{ fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, lib
, flutter
, gnome
, quickemu
}:
let
  runtimeBinDependencies = [ gnome.zenity ];
  versionMatches =
    builtins.match ''
      .*
      version:[[:blank:]]"([[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+)"
      .*
    '' (builtins.readFile ./pubspec.yaml);
in
flutter.buildFlutterApplication rec {
  pname = "quickgui";
  version = builtins.concatStringsSep "" versionMatches;
  src = fetchFromGitHub {
    owner = "quickemu-project";
    repo = "quickgui";
    #rev = version;
    rev = "d4893b5d2cb2e7ef271e4c2d66683e30d70352e2";
    hash = "sha256-V9wSENva/5Khqzor+Umj7BooWecDqn91Bj+waDMMPyY=";
  };
  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    window_size = "sha256-mn1UFA4Vqh3f5MqlTy9LueWr6qvCOHLujVoEQi0KMNw=";
  };

  # These things are added to LD_LIBRARY_PATH, but not PATH
  runtimeDependencies = [ quickemu ];
  extraWrapProgramArgs = "--prefix PATH : ${lib.makeBinPath runtimeBinDependencies}";

  nativeBuildInputs = [ copyDesktopItems ];

  postFixup = ''
    mkdir -p $out/share/pixmaps
    cp $out/app/data/flutter_assets/assets/images/logo_pink.png $out/share/pixmaps/quickemu.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "quickgui";
      exec = "quickgui";
      icon = "quickgui";
      desktopName = "Quickgui";
      categories = [ "Development" "System" ];
    })
  ];

  meta = with lib; {
    description = "Flutter frontend for quickemu";
    homepage = "https://github.com/quickemu-project/quickgui";
    changelog = "https://github.com/quickemu-project/quickgui/releases/";
    license = licenses.mit;
    maintainers = with maintainers; [ flexiondotorg heyimnova ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "quickgui";
  };
}
