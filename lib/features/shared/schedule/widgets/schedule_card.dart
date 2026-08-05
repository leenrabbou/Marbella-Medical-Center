import 'package:marbella/core/widgets/style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/features/shared/schedule/models/schedule_model.dart';
import 'package:marbella/generated/l10n.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.day,
    required this.schedules,
    required this.onDelete,
  });
  final String day;
  final List<ScheduleModel> schedules;
  final Function(ScheduleModel) onDelete;
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: StyleWidget.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4.h),
          if (schedules.isEmpty)
            Text(
              S.of(context).no_working_hours,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color.onSurface.withAlpha((0.5 * 255).toInt()),
              ),
            )
          else
            Column(
              children: schedules.map((s) {
                return Container(
                  margin: EdgeInsets.only(bottom: 5.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: s.isActive
                        ? color.primary.withAlpha((0.1 * 255).toInt())
                        : Colors.grey.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, size: 20, color: color.primary),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${s.startTime} - ${s.endTime}",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${S.of(context).slot} ${s.slotDuration} ${S.of(context).min}",
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: color.onSurface.withAlpha(
                                      (0.5 * 255).toInt(),
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
