import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
  }) {
    final colors = _snackbarColors(context, type);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          width: 700,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: colors.border, width: 1.2),
              ),
              child: Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: colors.iconBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(colors.icon, color: Colors.white, size: 22),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  static _SnackbarStyle _snackbarColors(
    BuildContext context,
    SnackbarType type,
  ) {
    final primary = Theme.of(context).colorScheme.primary;

    switch (type) {
      case SnackbarType.success:
        return _SnackbarStyle(
          background: primary.withAlpha((0.5 * 255).toInt()),
          border: primary.withAlpha((0.1 * 255).toInt()),
          shadow: primary.withAlpha((0.1 * 255).toInt()),
          iconBackground: primary.withAlpha((0.5 * 255).toInt()),
          icon: Icons.check_rounded,
        );

      case SnackbarType.error:
        return _SnackbarStyle(
          background: const Color(0xFFD94040).withAlpha((0.5 * 255).toInt()),
          border: const Color(0xFFD94040).withAlpha((0.1 * 255).toInt()),
          shadow: const Color(0xFFD94040).withAlpha((0.1 * 255).toInt()),
          iconBackground: const Color(
            0xFFD94040,
          ).withAlpha((0.5 * 255).toInt()),
          icon: Icons.close_rounded,
        );

      case SnackbarType.info:
        return _SnackbarStyle(
          background: const Color(0xFF9E9E9E).withAlpha((0.8 * 255).toInt()),
          border: const Color(0xFF9E9E9E).withAlpha((0.1 * 255).toInt()),
          shadow: const Color(0xFF9E9E9E).withAlpha((0.1 * 255).toInt()),
          iconBackground: const Color(0xFF9E9E9E),
          icon: Icons.info_rounded,
        );
    }
  }
}

enum SnackbarType { success, error, info }

class _SnackbarStyle {
  final Color background;
  final Color border;
  final Color shadow;
  final Color iconBackground;
  final IconData icon;

  _SnackbarStyle({
    required this.background,
    required this.border,
    required this.shadow,
    required this.iconBackground,
    required this.icon,
  });
}
