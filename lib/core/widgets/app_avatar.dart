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
  });
  final String? imageUrl;
  final String? initials;
  final String? fallbackAsset;
  final Color? color;
  final IconData? icon;

  final double size;
  final bool border;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final avatarColor = color ?? colorScheme.primary;

    Widget content;

    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      content = ClipOval(
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
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
        shape: BoxShape.circle,
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
    if (fallbackAsset != null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: border
            ? Colors.transparent
            : avatarColor.withAlpha((0.8 * 255).toInt()),
        child: Image.asset(fallbackAsset!, fit: BoxFit.contain),
      );
    }
    if (icon != null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: border
            ? Colors.transparent
            : avatarColor.withAlpha((0.2 * 255).toInt()),
        child: Icon(icon, color: avatarColor),
      );
    }
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: avatarColor.withAlpha((0.2 * 255).toInt()),
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
