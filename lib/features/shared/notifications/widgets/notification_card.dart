import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/shared/notifications/models/notification_model.dart';

class NotificationCardWidget extends StatelessWidget {
  const NotificationCardWidget({
    super.key,
    required this.notification,
    required this.isArabic,
    this.onTap,
  });

  final NotificationModel notification;
  final bool isArabic;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isUnread = !notification.isRead;
    bool isMobile = DeviceInfo.isMobile(context);
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 5.h : 8.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 30.w : 15.w,
              vertical: isMobile ? 4.h : 4.h,
            ),
            decoration: StyleWidget.cardDecoration(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: isMobile ? 100.r : 35.r,
                  height: isMobile ? 100.r : 35.r,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha((0.15 * 255).toInt()),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.notifications,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: isMobile ? 20.w : 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title(isArabic),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: isUnread
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 2.h : 4.h),
                      Text(
                        notification.body(isArabic),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withAlpha(
                            (0.65 * 255).toInt(),
                          ),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
