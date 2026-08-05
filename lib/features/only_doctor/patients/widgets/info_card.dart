import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/patients/models/patient_model.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.patient});
  final PatientModel patient;
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    bool isMobile = DeviceInfo.isMobile(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: StyleWidget.cardDecoration(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S().patient_info,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.h),
          Divider(
            height: 3,
            color: colorScheme.onSurface.withAlpha((0.05 * 255).toInt()),
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.height_outlined,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    S().height_label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withAlpha(
                        (0.7 * 255).toInt(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.w),
                  Text(
                    '100 ${S().cm}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.monitor_weight_outlined,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    S().weight_label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withAlpha(
                        (0.7 * 255).toInt(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.w),
                  Text(
                    '60 ${S().kg}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.bloodtype_outlined,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    S().blood_type,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withAlpha(
                        (0.7 * 255).toInt(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.w),
                  Text(
                    patient.bloodGroup,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: isMobile ? 50.h : 60.h),
        ],
      ),
    );
  }
}
