import 'package:flutter/material.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:window_manager/window_manager.dart';

class TitleBar extends StatelessWidget with PreferredSizeWidget {
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? actionsIconTheme;
  final bool? centerTitle;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final double? titleWidth;

  const TitleBar({
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.backgroundColor,
    this.foregroundColor,
    this.actionsIconTheme,
    this.centerTitle,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleWidth,
    this.titleTextStyle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformAppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      centerTitle: centerTitle,
      actionsIconTheme: actionsIconTheme,
      leading: leading,
      leadingWidth: leadingWidth,
      title: title,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      titleWidth: titleWidth,
      onDrag: () => windowManager.startDragging(),
      actions: [
        ...?actions,
        const PlatformWindowButtons(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
