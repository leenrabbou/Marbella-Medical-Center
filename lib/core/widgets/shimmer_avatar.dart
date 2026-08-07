import 'package:flutter/material.dart';

class ShimmerAvatar extends StatefulWidget {
  const ShimmerAvatar({super.key, required this.size, required this.label});

  final double size;
  final String label;

  @override
  State<ShimmerAvatar> createState() => _ShimmerAvatarState();
}

class _ShimmerAvatarState extends State<ShimmerAvatar> {
  bool _bright = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.surfaceContainerHighest.withAlpha(180);

    return TweenAnimationBuilder<double>(
      key: ValueKey(_bright),
      tween: Tween(begin: _bright ? 0.4 : 1.0, end: _bright ? 1.0 : 0.4),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      onEnd: () {
        if (mounted) setState(() => _bright = !_bright);
      },
      builder: (context, opacity, child) =>
          Opacity(opacity: opacity, child: child),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: baseColor),
        child: Center(
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withAlpha(45),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
