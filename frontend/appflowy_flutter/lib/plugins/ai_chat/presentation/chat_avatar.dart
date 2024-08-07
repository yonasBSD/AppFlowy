import 'package:flutter/material.dart';
import 'package:appflowy/generated/flowy_svgs.g.dart';
import 'package:appflowy/generated/locale_keys.g.dart';
import 'package:appflowy/util/built_in_svgs.dart';
import 'package:appflowy/util/color_generator/color_generator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowy_infra/size.dart';
import 'package:flowy_infra_ui/style_widget/text.dart';
import 'package:string_validator/string_validator.dart';

const defaultAvatarSize = 30.0;

class ChatChatUserAvatar extends StatelessWidget {
  const ChatChatUserAvatar({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return const ChatBorderedCircleAvatar();
  }
}

class ChatBorderedCircleAvatar extends StatelessWidget {
  const ChatBorderedCircleAvatar({
    super.key,
    this.border = const BorderSide(),
    this.backgroundImage,
    this.child,
  });

  final BorderSide border;
  final ImageProvider<Object>? backgroundImage;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: defaultAvatarSize,
      child: CircleAvatar(
        backgroundColor: border.color,
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: CircleAvatar(
            backgroundImage: backgroundImage,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            child: child,
          ),
        ),
      ),
    );
  }
}

class ChatUserAvatar extends StatelessWidget {
  const ChatUserAvatar({
    super.key,
    required this.iconUrl,
    required this.name,
    this.size = defaultAvatarSize,
    this.isHovering = false,
    this.defaultName,
  });

  final String iconUrl;
  final String name;
  final double size;
  final String? defaultName;

  // If true, a border will be applied on top of the avatar
  final bool isHovering;

  @override
  Widget build(BuildContext context) {
    if (iconUrl.isEmpty) {
      return _buildEmptyAvatar(context);
    } else if (isURL(iconUrl)) {
      return _buildUrlAvatar(context);
    } else {
      return _buildEmojiAvatar(context);
    }
  }

  Widget _buildEmptyAvatar(BuildContext context) {
    final String nameOrDefault = _userName(name, defaultName);

    final Color color = ColorGenerator(name).toColor();
    const initialsCount = 2;

    // Taking the first letters of the name components and limiting to 2 elements
    final nameInitials = nameOrDefault
        .split(' ')
        .where((element) => element.isNotEmpty)
        .take(initialsCount)
        .map((element) => element[0].toUpperCase())
        .join();

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isHovering
            ? Border.all(
                color: _darken(color),
                width: 4,
              )
            : null,
      ),
      child: FlowyText.regular(
        nameInitials,
        color: Colors.black,
      ),
    );
  }

  Widget _buildUrlAvatar(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isHovering
              ? Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 4,
                )
              : null,
        ),
        child: ClipRRect(
          borderRadius: Corners.s5Border,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.network(
              iconUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _buildEmptyAvatar(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiAvatar(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isHovering
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 4,
                )
              : null,
        ),
        child: ClipRRect(
          borderRadius: Corners.s5Border,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: builtInSVGIcons.contains(iconUrl)
                ? FlowySvg(
                    FlowySvgData('emoji/$iconUrl'),
                    blendMode: null,
                  )
                : FlowyText.emoji(iconUrl),
          ),
        ),
      ),
    );
  }

  /// Return the user name, if the user name is empty,
  /// return the default user name.
  ///
  String _userName(String name, String? defaultName) =>
      name.isEmpty ? (defaultName ?? LocaleKeys.defaultUsername.tr()) : name;

  /// Used to darken the generated color for the hover border effect.
  /// The color is darkened by 15% - Hence the 0.15 value.
  ///
  Color _darken(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
  }
}
