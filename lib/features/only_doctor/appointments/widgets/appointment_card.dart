import 'package:marbella/core/widgets/style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/features/only_doctor/appointments/views/appointment_details_view.dart';
import 'package:marbella/features/only_doctor/appointments/models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.isFromPatient,
  });
  final AppointmentModel appointment;
  final bool isFromPatient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = Constant.statusColor(appointment.status);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return AppointmentDetailsView(
                  appointment: appointment,
                  isFromPatient: isFromPatient,
                );
              },
            ),
          );
        },
        child: Container(
          decoration: StyleWidget.cardDecoration(context),

          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 5.w,
                child: Container(color: statusColor),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '${appointment.startTime.substring(11, 16)} - ${appointment.endTime.substring(11, 16)}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.onSurface.withAlpha(
                              (0.3 * 255).toInt(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          Constant.formatDate(
                            context,
                            appointment.startTime.substring(0, 10),
                          ),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface.withAlpha(
                              (0.6 * 255).toInt(),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha((0.12 * 255).toInt()),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            appointment.status,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),
                    Divider(
                      height: 0.5,
                      color: colorScheme.onSurface.withAlpha(
                        (0.08 * 255).toInt(),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      '${appointment.patient.givenName} ${appointment.patient.familyName}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 8.h),

                    _InfoRow(
                      icon: Icons.phone_android_outlined,
                      text: appointment.patient.phoneNumber,
                      colorScheme: colorScheme,
                      theme: theme,
                    ),
                    SizedBox(height: 5.h),
                    _InfoRow(
                      icon: Icons.medical_services_outlined,
                      text: appointment.service.name,
                      colorScheme: colorScheme,
                      theme: theme,
                    ),
                    SizedBox(height: 5.h),
                    _InfoRow(
                      icon: Icons.local_hospital_outlined,
                      text: appointment.clinic.name,
                      colorScheme: colorScheme,
                      theme: theme,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    required this.colorScheme,
    required this.theme,
  });

  final IconData icon;
  final String text;
  final ColorScheme colorScheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: colorScheme.primary.withAlpha((0.8 * 255).toInt()),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withAlpha((0.65 * 255).toInt()),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
