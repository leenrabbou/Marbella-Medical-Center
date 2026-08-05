import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChipeItem extends StatelessWidget {
  const ChipeItem({
    super.key,
    required this.text,
    required this.icon,
    required this.number,
    required this.isCondition,
  });
  final String text;
  final IconData icon;
  final String number;
  final bool isCondition;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: colorScheme.primary),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: Theme.of(context).textTheme.bodySmall),

              isCondition
                  ? SizedBox.shrink()
                  : Text(
                      number,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(
                          (0.5 * 255).toInt(),
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
