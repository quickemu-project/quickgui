import 'package:flutter/material.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:window_manager/window_manager.dart';

class TitleBar extends PlatformAppBar {
  TitleBar({
    List<Widget>? actions,
    super.backgroundColor,
    super.centerTitle,
    super.leading,
    super.leadingWidth,
    super.title,
    super.titleSpacing,
    super.toolbarOpacity,
    super.toolbarTextStyle,
    super.titleTextStyle,
    super.actionsIconTheme,
    super.automaticallyImplyLeading,
    super.foregroundColor,
    super.titleWidth,
    super.key,
  }) : super(
          actions: [
            ...actions ?? [],
            const PlatformWindowButtons(),
          ],
        );

  @override
  Widget build(BuildContext context) {
    return DragToMoveArea(child: super.build(context));
  }
}
