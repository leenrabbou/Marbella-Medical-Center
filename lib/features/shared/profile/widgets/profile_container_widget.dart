import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/device_info.dart';

class ProfileContainerWidget extends StatelessWidget {
  const ProfileContainerWidget({
    super.key,
    required this.title,
    required this.text,
    required this.icon,
  });
  final String title, text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    bool isMobile = DeviceInfo.isMobile(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: isMobile ? 3.h : 4.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withAlpha((0.03 * 255).toInt()),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 24),
            SizedBox(width: 20.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.5 * 255).toInt()),
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
