import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/widgets/app_avatar.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/medications/models/medication_model.dart';
import 'package:marbella/features/only_doctor/medications/views/medication_details_view.dart';
import 'package:marbella/features/only_doctor/medications/widgets/medication_info_chip.dart';

class MedicationCard extends StatelessWidget {
  const MedicationCard({
    super.key,
    required this.medication,
    this.onEdit,
    this.onDelete,
    required this.showDescreption,
    required this.isFromDetailsView,
  });

  final MedicationModel medication;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showDescreption;
  final bool isFromDetailsView;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasDescription =
        showDescreption &&
        medication.description != null &&
        medication.description!.trim().isNotEmpty;
    final hasStrength = medication.strength != null;

    bool isMobile = DeviceInfo.isMobile(context);
    return GestureDetector(
      onTap: isFromDetailsView
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MedicationDetailsView(
                    medication: medication,
                    onEdit: onEdit,
                    onDelete: onDelete,
                  ),
                ),
              );
            },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 30.w : 10.w,
          vertical: 8.h,
        ),
        decoration: StyleWidget.cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppAvatar(
                  icon: Icons.medication_outlined,
                  size: isMobile
                      ? 150.r
                      : isFromDetailsView
                      ? 85.r
                      : 85.r,
                  imageUrl: medication.image?.url,
                  isCircular: false,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.code.display,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Wrap(
                        spacing: 4.w,
                        runSpacing: 4.h,
                        children: [
                          MedicationInfoChip(
                            icon: Icons.medication_liquid_outlined,
                            label: medication.form,
                            color: colorScheme.primary,
                          ),
                          if (hasStrength)
                            MedicationInfoChip(
                              icon: Icons.science_outlined,
                              label: medication.strength!,
                              color: colorScheme.primary,
                            ),
                        ],
                      ),
                      if (hasDescription) ...[                        
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withAlpha(0),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    medication.description!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
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
