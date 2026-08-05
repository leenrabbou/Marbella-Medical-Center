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
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 5.w,
                  decoration: BoxDecoration(
                    color: Constant.statusColor(appointment.status),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      bottomLeft: Radius.circular(8.r),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${appointment.startTime.substring(11, 16)} - ${appointment.endTime.substring(11, 16)}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              Constant.formatDate(
                                context,
                                appointment.startTime.substring(0, 10),
                              ),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                        VerticalDivider(
                          indent: 5,
                          endIndent: 5,
                          width: 30.w,
                          color: colorScheme.onSurface.withAlpha(
                            (0.3 * 255).toInt(),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${appointment.patient.givenName} ${appointment.patient.familyName}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_android_outlined,
                                    size: 15,
                                    color: colorScheme.primary,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    appointment.patient.phoneNumber,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.medical_services_outlined,
                                    size: 15,
                                    color: colorScheme.primary,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    appointment.service.name,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: 100.w,
                              padding: EdgeInsets.symmetric(vertical: 3.h),
                              decoration: BoxDecoration(
                                color: Constant.statusColor(
                                  appointment.status,
                                ).withAlpha((0.1 * 255).toInt()),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  appointment.status,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Constant.statusColor(
                                          appointment.status,
                                        ),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              children: [
                                Container(
                                  width: 100.w,
                                  padding: EdgeInsets.symmetric(vertical: 3.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: colorScheme.primary.withAlpha(
                                        (0.5 * 255).toInt(),
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      appointment.clinic.name,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: 10.w),
                      ],
                    ),
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
