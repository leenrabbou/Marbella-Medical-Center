import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeLineItem extends StatelessWidget {
  const TimeLineItem({
    super.key,
    required this.color,
    required this.icon,
    required this.subtitle,
    required this.title,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(9.r),
          decoration: BoxDecoration(
            color: color.withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.circular(11.r),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withAlpha((0.55 * 255).toInt()),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
