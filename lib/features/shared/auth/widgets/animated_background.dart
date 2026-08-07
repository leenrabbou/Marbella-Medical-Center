import 'package:marbella/features/shared/auth/widgets/medical_pattern_painter.dart';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Color color;

  const AnimatedBackground({super.key, required this.color});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Stack(
          children: [
            Positioned(
              left: -120 + controller.value * 60,
              top: -80,
              child: _glowCircle(280, widget.color),
            ),
            Positioned(
              right: -100,
              bottom: -60 + controller.value * 70,
              child: _glowCircle(240, Colors.cyan),
            ),
            Positioned(
              right: 40 - controller.value * 40,
              top: 220,
              child: _glowCircle(170, Colors.teal),
            ),
            Positioned.fill(
              child: CustomPaint(painter: MedicalPatternPainter(widget.color)),
            ),
          ],
        );
      },
    );
  }
}

Widget _glowCircle(double size, Color color) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [color.withAlpha(35), color.withAlpha(0)],
      ),
    ),
  );
}
