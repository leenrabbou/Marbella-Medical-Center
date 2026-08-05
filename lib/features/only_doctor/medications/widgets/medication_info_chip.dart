import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicationInfoChip extends StatelessWidget {
  const MedicationInfoChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData? icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withAlpha((0.05 * 255).toInt()),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: color.withAlpha((0.55 * 255).toInt())),
            const SizedBox(width: 5),
          ],

          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color.withAlpha((0.75 * 255).toInt()),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
