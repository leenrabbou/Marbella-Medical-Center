import 'package:marbella/core/widgets/app_avatar.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/medications/models/medication_model.dart';
import 'package:marbella/features/only_doctor/medications/widgets/medication_info_chip.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicationCard extends StatelessWidget {
  const MedicationCard({
    super.key,
    required this.medication,
    this.onEdit,
    this.onDelete,
    required this.showDescreption,
  });

  final MedicationModel medication;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showDescreption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasDescription = medication.description != null && showDescreption;
    final hasStrength = medication.strength != null;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: StyleWidget.cardDecoration(context),
      child: Row(
        children: [
          AppAvatar(
            icon: Icons.medication_outlined,
            size: 60.w,
            imageUrl: medication.image?.url,
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        medication.code.display,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (showDescreption)
                      SizedBox(
                        height: 10.h,
                        width: 20.w,
                        child: PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.more_vert,
                            size: 20,
                            color: colorScheme.onSurface.withAlpha(
                              (0.5 * 255).toInt(),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          color: colorScheme.surface,
                          onSelected: (value) {
                            if (value == 'edit') onEdit?.call();
                            if (value == 'delete') onDelete?.call();
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    size: 20,
                                    color: colorScheme.onSurface.withAlpha(
                                      (0.5 * 255).toInt(),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    S().edit,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    S().delete,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 2.h),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    MedicationInfoChip(
                      icon: Icons.medication_liquid_outlined,
                      label: medication.form,
                      color: theme.colorScheme.primary,
                    ),
                    if (hasStrength)
                      MedicationInfoChip(
                        icon: Icons.science_outlined,
                        label: medication.strength!,
                        color: theme.colorScheme.primary,
                      ),
                  ],
                ),
                if (hasDescription) ...[
                  SizedBox(height: 5.h),
                  Text(
                    medication.description ?? '-',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(
                        (0.75 * 255).toInt(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
