import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickgui/main.dart' as app;
import 'package:quickgui/src/model/osicons.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads OS icons from the bundled binary asset manifest', () async {
    final previousIcons = Map<String, String>.of(osIcons);
    addTearDown(() {
      osIcons
        ..clear()
        ..addAll(previousIcons);
    });
    osIcons.clear();

    // Use the asset bundle produced by Flutter, without a mock manifest.
    await expectLater(
      rootBundle.loadString('AssetManifest.json'),
      throwsA(isA<FlutterError>()),
    );
    rootBundle.evict('AssetManifest.json');

    await app.getIcons();

    expect(osIcons, containsPair('ubuntu', 'assets/quickemu-icons/ubuntu.svg'));
    expect(
      osIcons,
      containsPair('windows', 'assets/quickemu-icons/windows.svg'),
    );
    expect(osIcons, containsPair('macos', 'assets/quickemu-icons/macos.svg'));
    expect(await rootBundle.loadString(osIcons['ubuntu']!), contains('<svg'));
  });
}
