import 'package:flutter/material.dart';

class ShimmerAvatar extends StatefulWidget {
  const ShimmerAvatar({super.key, required this.size, required this.label});

  final double size;
  final String label;

  @override
  State<ShimmerAvatar> createState() => _ShimmerAvatarState();
}

class _ShimmerAvatarState extends State<ShimmerAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final baseColor = colorScheme.surfaceContainerHighest.withAlpha(180);

    final highlightColor = Colors.white.withAlpha(120);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
                color: Colors.black.withAlpha(12),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment(-1.0 + (_controller.value * 2), -0.3),
              end: Alignment(1.0 + (_controller.value * 2), 0.3),
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.25, 0.5, 0.75],
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withAlpha(45),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
