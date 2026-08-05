import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyleWidget {
  static BoxDecoration cardDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return BoxDecoration(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: [
        BoxShadow(
          blurRadius: 16,
          spreadRadius: 1,
          offset: const Offset(0, 6),
          color: Colors.black.withAlpha((0.04 * 255).toInt()),
        ),
      ],
    );
  }

  static OutlineInputBorder border(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(
        color: colorScheme.onSurface.withAlpha((0.1 * 255).toInt()),
      ),
    );
  }

  static OutlineInputBorder focusedBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: 1.4,
      ),
    );
  }

  static InputDecoration buildDropdownInputDecoration(
    BuildContext context, {
    bool? icons,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InputDecoration(
      prefixIcon: icons != null ? Icon(Icons.search, size: 20) : null,
      filled: true,
      fillColor: colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: colorScheme.onSurface.withAlpha((0.1 * 255).toInt()),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: colorScheme.onSurface.withAlpha((0.1 * 255).toInt()),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
      ),
    );
  }
}
