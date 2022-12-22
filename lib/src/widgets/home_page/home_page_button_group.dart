import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:tuple/tuple.dart';

import '../../model/operating_system.dart';
import '../../model/option.dart';
import '../../model/version.dart';
import '../../pages/downloader.dart';
import '../../pages/operating_system_selection.dart';
import '../../pages/version_selection.dart';

class ProgressArrowPainter extends CustomPainter {
  final Color? oddColor;
  final Color? evenColor;
  final double radius;
  const ProgressArrowPainter({
    this.oddColor,
    this.evenColor,
    this.radius = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const icon = Icons.arrow_right_alt_rounded;
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final spacing = (radius + 1) * 2;
    final balls = ((size.width / spacing) - 2).abs();

    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        color: balls % 2 != 0
            ? evenColor ?? Colors.grey[500]!
            : oddColor ?? Colors.grey[600]!,
        fontSize: 30,
        fontFamily: icon.fontFamily,
        package:
            icon.fontPackage, // This line is mandatory for external icon packs
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(spacing * (balls).abs(), size.height / 2 - 15),
    );

    for (var i = 0; i < balls; i++) {
      if (i % 2 == 0) {
        paint.color = evenColor ?? Colors.grey[500]!;
      } else {
        paint.color = oddColor ?? Colors.grey[600]!;
      }
      canvas.drawCircle(
        Offset((size.height / 2) + i * spacing, size.height / 2),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ProgressArrow extends StatelessWidget {
  const ProgressArrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(top: 30),
      child: const CustomPaint(
        painter: ProgressArrowPainter(),
      ),
    );
  }
}

class HomePageButtonGroup extends StatefulWidget {
  const HomePageButtonGroup({Key? key}) : super(key: key);

  @override
  State<HomePageButtonGroup> createState() => _HomePageButtonGroupState();
}

class _HomePageButtonGroupState extends State<HomePageButtonGroup> {
  OperatingSystem? _selectedOperatingSystem;
  Version? _selectedVersion;
  Option? _selectedOption;

  @override
  Widget build(BuildContext context) {
    var _versionButtonLabel =
        _selectedVersion?.version ?? context.t('Select...');
    if (_selectedOption?.option.isNotEmpty ?? false) {
      _versionButtonLabel = "$_versionButtonLabel (${_selectedOption!.option})";
    }
    return Row(
      children: [
        Column(
          children: [
            PlatformText(context.t("Operating system")),
            const SizedBox(height: 10),
            PlatformFilledButton(
              child: Row(
                children: [
                  _selectedOperatingSystem != null
                      ? SvgPicture.asset(
                          "assets/quickemu-icons/${_selectedOperatingSystem!.code}.svg",
                          width: 32,
                          height: 32,
                          key: ValueKey(_selectedOperatingSystem?.code),
                          placeholderBuilder: (context) {
                            return const Icon(
                                Icons.settings_applications_sharp);
                          },
                        )
                      : const Icon(Icons.settings_applications_sharp),
                  const SizedBox(width: 8),
                  PlatformText(
                    _selectedOperatingSystem == null
                        ? context.t('Select...')
                        : _selectedOperatingSystem!.name,
                  ),
                ],
              ),
              onPressed: () async {
                final selection =
                    await Navigator.of(context).push<OperatingSystem>(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => const OperatingSystemSelection(),
                  ),
                );

                if (selection != null) {
                  setState(() {
                    _selectedOperatingSystem = selection;
                    if (selection.versions.length == 1 &&
                        selection.versions.first.options.length == 1) {
                      _selectedVersion = selection.versions.first;
                      _selectedOption = selection.versions.first.options.first;
                    } else {
                      _selectedVersion = null;
                      _selectedOption = null;
                    }
                  });
                }
              },
            ),
          ],
        ),
        const Expanded(
          child: ProgressArrow(),
        ),
        Column(
          children: [
            PlatformText(context.t("Version")),
            const SizedBox(height: 10),
            PlatformFilledButton(
              child: Row(
                children: [
                  const Icon(Icons.numbers_rounded),
                  const SizedBox(width: 8),
                  PlatformText(_versionButtonLabel),
                ],
              ),
              isSecondary: _selectedOperatingSystem == null,
              onPressed: (_selectedOperatingSystem != null)
                  ? () {
                      Navigator.of(context)
                          .push<Tuple2<Version, Option?>>(MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => VersionSelection(
                            operatingSystem: _selectedOperatingSystem!),
                      ))
                          .then((selection) {
                        if (selection != null) {
                          setState(() {
                            _selectedVersion = selection.item1;
                            _selectedOption = selection.item2;
                          });
                        }
                      });
                    }
                  : null,
            ),
          ],
        ),
        const Expanded(
          child: ProgressArrow(),
        ),
        Column(
          children: [
            PlatformText(context.t('Download')),
            const SizedBox(height: 10),
            PlatformFilledButton(
              child: Row(
                children: [
                  const Icon(Icons.file_download_outlined),
                  const SizedBox(width: 8),
                  PlatformText(context.t('Download')),
                ],
              ),
              isSecondary: _selectedVersion == null,
              onPressed: (_selectedVersion == null)
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Downloader(
                            operatingSystem: _selectedOperatingSystem!,
                            version: _selectedVersion!,
                            option: _selectedOption,
                          ),
                        ),
                      );
                    },
            ),
          ],
        ),
      ],
    );
  }

  void showLoadingIndicator({String text = ''}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          backgroundColor: Colors.black87,
          content: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: PlatformText(context.t('Downloading...'),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Colors.white)),
                ),
                const CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: PlatformText(
                    'Target : ${Directory.current.absolute.path}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void hideLoadingIndicator() {
    Navigator.of(context).pop();
  }

  void showDoneDialog(
      {required String operatingSystem, required String version}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          backgroundColor: Colors.black87,
          content: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: PlatformText(context.t('Done !'),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Colors.white)),
                ),
                PlatformText(
                    context.t('Now run {0} to start the VM',
                        args: ["quickemu --vm $operatingSystem-$version"]),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: Colors.white)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: PlatformText(
                      'Dismiss',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
