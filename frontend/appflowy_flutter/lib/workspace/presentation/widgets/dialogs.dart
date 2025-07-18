import 'package:appflowy/generated/flowy_svgs.g.dart';
import 'package:appflowy/generated/locale_keys.g.dart';
import 'package:appflowy/workspace/presentation/home/menu/sidebar/space/shared_widget.dart';
import 'package:appflowy_ui/appflowy_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowy_infra/size.dart';
import 'package:flowy_infra_ui/style_widget/text.dart';
import 'package:flowy_infra_ui/widget/buttons/primary_button.dart';
import 'package:flowy_infra_ui/widget/buttons/secondary_button.dart';
import 'package:flowy_infra_ui/widget/dialog/styled_dialogs.dart';
import 'package:flowy_infra_ui/widget/spacing.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:universal_platform/universal_platform.dart';

export 'package:flowy_infra_ui/widget/dialog/styled_dialogs.dart';
export 'package:toastification/toastification.dart';

class NavigatorCustomDialog extends StatefulWidget {
  const NavigatorCustomDialog({
    super.key,
    required this.child,
    this.cancel,
    this.confirm,
    this.hideCancelButton = false,
  });

  final Widget child;
  final void Function()? cancel;
  final void Function()? confirm;
  final bool hideCancelButton;

  @override
  State<NavigatorCustomDialog> createState() => _NavigatorCustomDialog();
}

class _NavigatorCustomDialog extends State<NavigatorCustomDialog> {
  @override
  Widget build(BuildContext context) {
    return StyledDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ...[
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
                maxHeight: 260,
              ),
              child: widget.child,
            ),
          ],
          if (widget.confirm != null) ...[
            const VSpace(20),
            OkCancelButton(
              onOkPressed: () {
                widget.confirm?.call();
                Navigator.of(context).pop();
              },
              onCancelPressed: widget.hideCancelButton
                  ? null
                  : () {
                      widget.cancel?.call();
                      Navigator.of(context).pop();
                    },
            ),
          ],
        ],
      ),
    );
  }
}

class NavigatorAlertDialog extends StatefulWidget {
  const NavigatorAlertDialog({
    super.key,
    required this.title,
    this.cancel,
    this.confirm,
    this.hideCancelButton = false,
    this.constraints,
  });

  final String title;
  final void Function()? cancel;
  final void Function()? confirm;
  final bool hideCancelButton;
  final BoxConstraints? constraints;

  @override
  State<NavigatorAlertDialog> createState() => _CreateFlowyAlertDialog();
}

class _CreateFlowyAlertDialog extends State<NavigatorAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return StyledDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ...[
            ConstrainedBox(
              constraints: widget.constraints ??
                  const BoxConstraints(
                    maxWidth: 400,
                    maxHeight: 260,
                  ),
              child: FlowyText.medium(
                widget.title,
                fontSize: FontSizes.s16,
                textAlign: TextAlign.center,
                color: Theme.of(context).colorScheme.tertiary,
                maxLines: null,
              ),
            ),
          ],
          if (widget.confirm != null) ...[
            const VSpace(20),
            OkCancelButton(
              onOkPressed: () {
                widget.confirm?.call();
                Navigator.of(context).pop();
              },
              onCancelPressed: widget.hideCancelButton
                  ? null
                  : () {
                      widget.cancel?.call();
                      Navigator.of(context).pop();
                    },
            ),
          ],
        ],
      ),
    );
  }
}

class NavigatorOkCancelDialog extends StatelessWidget {
  const NavigatorOkCancelDialog({
    super.key,
    this.onOkPressed,
    this.onCancelPressed,
    this.okTitle,
    this.cancelTitle,
    this.title,
    this.message,
    this.maxWidth,
    this.titleUpperCase = true,
    this.autoDismiss = true,
  });

  final VoidCallback? onOkPressed;
  final VoidCallback? onCancelPressed;
  final String? okTitle;
  final String? cancelTitle;
  final String? title;
  final String? message;
  final double? maxWidth;
  final bool titleUpperCase;
  final bool autoDismiss;

  @override
  Widget build(BuildContext context) {
    final onCancel = onCancelPressed == null
        ? null
        : () {
            onCancelPressed?.call();
            if (autoDismiss) {
              Navigator.of(context).pop();
            }
          };
    return StyledDialog(
      maxWidth: maxWidth ?? 500,
      padding: EdgeInsets.symmetric(horizontal: Insets.xl, vertical: Insets.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null) ...[
            FlowyText.medium(
              titleUpperCase ? title!.toUpperCase() : title!,
              fontSize: FontSizes.s16,
              maxLines: 3,
            ),
            VSpace(Insets.sm * 1.5),
            Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              height: 1,
            ),
            VSpace(Insets.m * 1.5),
          ],
          if (message != null)
            FlowyText.medium(
              message!,
              maxLines: 3,
            ),
          SizedBox(height: Insets.l),
          OkCancelButton(
            onOkPressed: () {
              onOkPressed?.call();
              if (autoDismiss) {
                Navigator.of(context).pop();
              }
            },
            onCancelPressed: onCancel,
            okTitle: okTitle?.toUpperCase(),
            cancelTitle: cancelTitle?.toUpperCase(),
          ),
        ],
      ),
    );
  }
}

class OkCancelButton extends StatelessWidget {
  const OkCancelButton({
    super.key,
    this.onOkPressed,
    this.onCancelPressed,
    this.okTitle,
    this.cancelTitle,
    this.minHeight,
    this.alignment = MainAxisAlignment.spaceAround,
    this.mode = TextButtonMode.big,
  });

  final VoidCallback? onOkPressed;
  final VoidCallback? onCancelPressed;
  final String? okTitle;
  final String? cancelTitle;
  final double? minHeight;
  final MainAxisAlignment alignment;
  final TextButtonMode mode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: alignment,
        children: <Widget>[
          if (onCancelPressed != null)
            SecondaryTextButton(
              cancelTitle ?? LocaleKeys.button_cancel.tr(),
              onPressed: onCancelPressed,
              mode: mode,
            ),
          if (onCancelPressed != null) HSpace(Insets.m),
          if (onOkPressed != null)
            PrimaryTextButton(
              okTitle ?? LocaleKeys.button_ok.tr(),
              onPressed: onOkPressed,
              mode: mode,
            ),
        ],
      ),
    );
  }
}

ToastificationItem showToastNotification({
  BuildContext? context,
  String? message,
  TextSpan? richMessage,
  String? description,
  ToastificationType type = ToastificationType.success,
  ToastificationCallbacks? callbacks,
  bool showCloseButton = false,
  double bottomPadding = 100,
}) {
  assert(
    (message == null) != (richMessage == null),
    "Exactly one of message or richMessage must be non-null.",
  );
  return toastification.showCustom(
    context: context,
    alignment: Alignment.bottomCenter,
    autoCloseDuration: const Duration(milliseconds: 3000),
    callbacks: callbacks ?? const ToastificationCallbacks(),
    builder: (_, item) {
      return UniversalPlatform.isMobile
          ? _MobileToast(
              message: message,
              type: type,
              bottomPadding: bottomPadding,
              description: description,
            )
          : DesktopToast(
              message: message,
              richMessage: richMessage,
              type: type,
              onDismiss: () => toastification.dismiss(item),
              showCloseButton: showCloseButton,
            );
    },
  );
}

class _MobileToast extends StatelessWidget {
  const _MobileToast({
    this.message,
    this.type = ToastificationType.success,
    this.bottomPadding = 100,
    this.description,
  });

  final String? message;
  final ToastificationType type;
  final double bottomPadding;
  final String? description;

  @override
  Widget build(BuildContext context) {
    if (message == null) {
      return const SizedBox.shrink();
    }
    final hintText = FlowyText.regular(
      message!,
      fontSize: 16.0,
      figmaLineHeight: 18.0,
      color: Colors.white,
      maxLines: 10,
    );
    final descriptionText = description != null
        ? FlowyText.regular(
            description!,
            fontSize: 12,
            color: Colors.white,
            maxLines: 10,
          )
        : null;
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(
        bottom: bottomPadding,
        left: 16,
        right: 16,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 13.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: const Color(0xE5171717),
        ),
        child: type == ToastificationType.success
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (type == ToastificationType.success) ...[
                        const FlowySvg(
                          FlowySvgs.success_s,
                          blendMode: null,
                        ),
                        const HSpace(8.0),
                      ],
                      Expanded(child: hintText),
                    ],
                  ),
                  if (descriptionText != null) ...[
                    const VSpace(4.0),
                    descriptionText,
                  ],
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  hintText,
                  if (descriptionText != null) ...[
                    const VSpace(4.0),
                    descriptionText,
                  ],
                ],
              ),
      ),
    );
  }
}

@visibleForTesting
class DesktopToast extends StatelessWidget {
  const DesktopToast({
    super.key,
    this.message,
    this.richMessage,
    required this.type,
    this.onDismiss,
    this.showCloseButton = false,
  });

  final String? message;
  final TextSpan? richMessage;
  final ToastificationType type;
  final void Function()? onDismiss;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final theme = AppFlowyTheme.of(context);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360.0),
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.xl,
          vertical: theme.spacing.l,
        ),
        margin: const EdgeInsets.only(bottom: 32.0),
        decoration: BoxDecoration(
          color: theme.surfaceColorScheme.inverse,
          borderRadius: BorderRadius.circular(theme.borderRadius.l),
          boxShadow: theme.shadow.small,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon
            FlowySvg(
              switch (type) {
                ToastificationType.warning => FlowySvgs.toast_warning_filled_s,
                ToastificationType.success => FlowySvgs.toast_checked_filled_s,
                ToastificationType.error => FlowySvgs.toast_error_filled_s,
                _ => throw UnimplementedError(),
              },
              size: const Size.square(20.0),
              blendMode: null,
            ),
            HSpace(
              theme.spacing.m,
            ),
            // text
            Flexible(
              child: message != null
                  ? Text(
                      message!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textStyle.body.standard(
                        color: theme.textColorScheme.onFill,
                      ),
                    )
                  : RichText(
                      text: richMessage!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            if (showCloseButton) ...[
              HSpace(
                theme.spacing.xl,
              ),
              // close
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onDismiss,
                  child: const SizedBox.square(
                    dimension: 24.0,
                    child: Center(
                      child: FlowySvg(
                        FlowySvgs.toast_close_s,
                        size: Size.square(20.0),
                        color: Color(0xFFBDBDBD),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<void> showConfirmDeletionDialog({
  required BuildContext context,
  required String name,
  required String description,
  required VoidCallback onConfirm,
}) {
  return showDialog(
    context: context,
    builder: (_) {
      final title = LocaleKeys.space_deleteConfirmation.tr() + name;
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SizedBox(
          width: 440,
          child: ConfirmPopup(
            title: title,
            description: description,
            onConfirm: (_) => onConfirm(),
          ),
        ),
      );
    },
  );
}

Future<void> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String description,
  TextStyle? titleStyle,
  TextStyle? descriptionStyle,
  void Function(BuildContext context)? onConfirm,
  VoidCallback? onCancel,
  String? confirmLabel,
  ConfirmPopupStyle style = ConfirmPopupStyle.onlyOk,
  WidgetBuilder? confirmButtonBuilder,
  Color? confirmButtonColor,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SizedBox(
          width: 440,
          child: ConfirmPopup(
            title: title,
            description: description,
            titleStyle: titleStyle,
            descriptionStyle: descriptionStyle,
            confirmButtonBuilder: confirmButtonBuilder,
            onConfirm: (_) => onConfirm?.call(context),
            onCancel: () => onCancel?.call(),
            confirmLabel: confirmLabel,
            style: style,
            confirmButtonColor: confirmButtonColor,
          ),
        ),
      );
    },
  );
}

Future<void> showCancelAndConfirmDialog({
  required BuildContext context,
  required String title,
  required String description,
  void Function(BuildContext context)? onConfirm,
  VoidCallback? onCancel,
  String? confirmLabel,
}) {
  return showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SizedBox(
          width: 440,
          child: ConfirmPopup(
            title: title,
            description: description,
            onConfirm: (context) => onConfirm?.call(context),
            confirmLabel: confirmLabel,
            confirmButtonColor: Theme.of(context).colorScheme.primary,
            onCancel: () => onCancel?.call(),
          ),
        ),
      );
    },
  );
}

Future<void> showCustomConfirmDialog({
  required BuildContext context,
  required String title,
  required String description,
  required Widget Function(BuildContext) builder,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  String? confirmLabel,
  ConfirmPopupStyle style = ConfirmPopupStyle.onlyOk,
  bool closeOnConfirm = true,
  bool showCloseButton = true,
  bool enableKeyboardListener = true,
  bool barrierDismissible = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SizedBox(
          width: 440,
          child: ConfirmPopup(
            title: title,
            description: description,
            onConfirm: (_) => onConfirm?.call(),
            onCancel: onCancel,
            confirmLabel: confirmLabel,
            confirmButtonColor: Theme.of(context).colorScheme.primary,
            style: style,
            closeOnAction: closeOnConfirm,
            showCloseButton: showCloseButton,
            enableKeyboardListener: enableKeyboardListener,
            child: builder(context),
          ),
        ),
      );
    },
  );
}

Future<void> showCancelAndDeleteDialog({
  required BuildContext context,
  required String title,
  required String description,
  Widget Function(BuildContext)? builder,
  VoidCallback? onDelete,
  String? confirmLabel,
  bool closeOnAction = false,
}) {
  return showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SizedBox(
          width: 440,
          child: ConfirmPopup(
            title: title,
            description: description,
            onConfirm: (_) => onDelete?.call(),
            closeOnAction: closeOnAction,
            confirmLabel: confirmLabel,
            confirmButtonColor: Theme.of(context).colorScheme.error,
            child: builder?.call(context),
          ),
        ),
      );
    },
  );
}
