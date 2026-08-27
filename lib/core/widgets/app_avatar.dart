import 'package:marbella/core/widgets/shimmer_avatar.dart';
import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.size,
    this.imageUrl,
    this.initials,
    this.fallbackAsset,
    this.color,
    this.border = false,
    this.icon,
    this.isCircular = true,
  });

  final String? imageUrl;
  final String? initials;
  final String? fallbackAsset;
  final Color? color;
  final IconData? icon;

  final double size;
  final bool border;
  final bool isCircular;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final avatarColor = color ?? colorScheme.primary;

    Widget content;

    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(isCircular ? size / 2 : 12),
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          cacheWidth: (size * 2).round(),
          cacheHeight: (size * 2).round(),
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: frame != null
                  ? child
                  : ShimmerAvatar(size: size, label: initials ?? ''),
            );
          },
          errorBuilder: (_, __, ___) => _fallback(context, avatarColor),
        ),
      );
    } else {
      content = _fallback(context, avatarColor);
    }

    if (!border) return content;

    return Container(
      width: size + 10,
      height: size + 10,
      decoration: BoxDecoration(
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircular ? null : BorderRadius.circular(12),
        border: Border.all(
          color: avatarColor.withAlpha((0.7 * 255).toInt()),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: content,
    );
  }

  Widget _fallback(BuildContext context, Color avatarColor) {
    final borderRadius = BorderRadius.circular(isCircular ? size / 2 : 12);

    if (fallbackAsset != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: border
              ? Colors.transparent
              : avatarColor.withAlpha((0.8 * 255).toInt()),
          borderRadius: borderRadius,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(fallbackAsset!, fit: BoxFit.contain),
      );
    }

    if (icon != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: border
              ? Colors.transparent
              : avatarColor.withAlpha((0.2 * 255).toInt()),
          borderRadius: borderRadius,
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: avatarColor),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: avatarColor.withAlpha((0.2 * 255).toInt()),
        borderRadius: borderRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        initials ?? '',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: avatarColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
