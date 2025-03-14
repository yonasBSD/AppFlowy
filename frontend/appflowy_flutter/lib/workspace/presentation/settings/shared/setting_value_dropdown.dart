import 'package:flowy_infra/theme_extension.dart';
import 'package:flowy_infra_ui/flowy_infra_ui.dart';
import 'package:flutter/material.dart';

class SettingValueDropDown extends StatefulWidget {
  const SettingValueDropDown({
    super.key,
    required this.currentValue,
    required this.popupBuilder,
    this.popoverKey,
    this.onClose,
    this.child,
    this.popoverController,
    this.offset,
    this.boxConstraints,
    this.margin = const EdgeInsets.all(6),
  });

  final String currentValue;
  final Key? popoverKey;
  final Widget Function(BuildContext) popupBuilder;
  final void Function()? onClose;
  final Widget? child;
  final PopoverController? popoverController;
  final Offset? offset;
  final BoxConstraints? boxConstraints;
  final EdgeInsets margin;

  @override
  State<SettingValueDropDown> createState() => _SettingValueDropDownState();
}

class _SettingValueDropDownState extends State<SettingValueDropDown> {
  @override
  Widget build(BuildContext context) {
    return AppFlowyPopover(
      key: widget.popoverKey,
      controller: widget.popoverController,
      direction: PopoverDirection.bottomWithCenterAligned,
      margin: widget.margin,
      popupBuilder: widget.popupBuilder,
      constraints: widget.boxConstraints ??
          const BoxConstraints(
            minWidth: 80,
            maxWidth: 160,
            maxHeight: 400,
          ),
      offset: widget.offset,
      onClose: widget.onClose,
      child: widget.child ??
          FlowyTextButton(
            widget.currentValue,
            fontColor: AFThemeExtension.maybeOf(context)?.onBackground,
            fillColor: Colors.transparent,
            onPressed: () {},
          ),
    );
  }
}
