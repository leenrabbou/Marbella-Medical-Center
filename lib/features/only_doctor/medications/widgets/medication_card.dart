import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.all(14.r),
        decoration: StyleWidget.cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppAvatar(
                  icon: Icons.medication_outlined,
                  size: isFromDetailsView ? 64.r : 52.r,
                  imageUrl: medication.image?.url,
                ),
                SizedBox(width: 12.w),
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
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 6.h,
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
                    ],
                  ),
                ),
              ],
            ),

            if (hasDescription) ...[
              SizedBox(height: 12.h),
              if (!isFromDetailsView)
                Text(
                  medication.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withAlpha(5),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notes, size: 18),
                          SizedBox(width: 6.w),
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
    );
  }
}
