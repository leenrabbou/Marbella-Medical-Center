import 'package:marbella/core/widgets/app_avatar.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/medications/widgets/medication_info_chip.dart';
import 'package:marbella/features/shared/patient_medications/models/patient_medication_model.dart';
import 'package:marbella/features/shared/patient_medications/views/patient_medication_details_view.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientMedicationCard extends StatelessWidget {
  const PatientMedicationCard({
    super.key,
    required this.patientMedication,
    required this.isEditable,
    this.onEdit,
    this.onDelete,
  });
  final PatientMedicationModel patientMedication;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isEditable;
  bool get _isActive {
    final untilRaw = patientMedication.untilDate;
    if (untilRaw == null || untilRaw.trim().isEmpty) return true;
    final until = DateTime.tryParse(untilRaw);
    if (until == null) return true;
    final today = DateTime.now();
    final untilDateOnly = DateTime(until.year, until.month, until.day);
    final todayDateOnly = DateTime(today.year, today.month, today.day);
    return !todayDateOnly.isAfter(untilDateOnly);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _isActive
        ? const Color(0xFF22C55E)
        : colorScheme.onSurface.withAlpha((0.5 * 255).toInt());
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PatientMedicationDetailsView(
              patientMedication: patientMedication,
              isEditable: isEditable,
              onDelete: onDelete,
              onEdit: onEdit,
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: StyleWidget.cardDecoration(context),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      AppAvatar(
                        icon: Icons.medication_outlined,
                        size: 60.w,
                        imageUrl: patientMedication.medication.image?.url,
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    patientMedication.medication.code.display,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(
                                          (0.06 * 255).toInt(),
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: statusColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        _isActive ? S().active : S().ended,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: statusColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11.5,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                MedicationInfoChip(
                                  icon: Icons.medication_liquid_outlined,
                                  label: patientMedication.dosage,
                                  color: colorScheme.primary,
                                ),
                                if (patientMedication.medication.strength !=
                                    null) ...[
                                  MedicationInfoChip(
                                    icon: Icons.medication_liquid_outlined,
                                    label:
                                        patientMedication.medication.strength!,
                                    color: colorScheme.primary,
                                  ),
                                ],
                                MedicationInfoChip(
                                  icon: Icons.timelapse_outlined,
                                  label:
                                      '${patientMedication.durationValue} ${patientMedication.durationUnit}',
                                  color: colorScheme.primary,
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                          ],
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
