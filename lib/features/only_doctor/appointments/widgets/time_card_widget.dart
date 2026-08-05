import 'package:marbella/core/widgets/style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/features/only_doctor/appointments/models/appointment_model.dart';

class TimeCardWidget extends StatelessWidget {
  const TimeCardWidget({
    super.key,
    required this.appointment,
    required this.statusColor,
  });
  final AppointmentModel appointment;
  final Color statusColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final duration = Constant.calDuration(
      appointment.startTime,
      appointment.endTime,
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: StyleWidget.cardDecoration(context),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Constant.formatDate(
                    context,
                    appointment.startTime.substring(0, 10),
                  ),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.secondary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  '${appointment.startTime.substring(11, 16)}  -  ${appointment.endTime.substring(11, 16)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              duration,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
