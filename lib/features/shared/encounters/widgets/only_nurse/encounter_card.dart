import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/shared/encounters/models/encounter_model.dart';
import 'package:marbella/features/shared/encounters/views/encounter_details_view.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EncounterCard extends StatelessWidget {
  final EncounterModel encounter;
  final VoidCallback? onTap;

  const EncounterCard({super.key, required this.encounter, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final patient = encounter.patient;
    final doctor = encounter.doctor;
    final hasReason =
        encounter.reason != null && encounter.reason!.trim().isNotEmpty;

    final Color statusColor = Constant.statusColor(encounter.status);

    bool isMobile = DeviceInfo.isMobile(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 40.w : 15.w,
        vertical: isMobile ? 3.h : 4.h,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap:
              onTap ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EncounterDetailsView(
                      encounter: encounter,
                      isFromPatientView: false,
                    ),
                  ),
                );
              },
          child: Container(
            decoration: StyleWidget.cardDecoration(context),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 30.w : 15.w,
              vertical: 8.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${patient.givenName} ${patient.familyName}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${patient.dateOfBirth} • ${Constant.calculateAge(patient.dateOfBirth)} ${S().years} • ${patient.bloodGroup}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withAlpha(
                                (0.5 * 255).toInt(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StatusBadge(status: encounter.status, color: statusColor),
                  ],
                ),
                SizedBox(height: 8.h),
                Divider(
                  height: 0.5,
                  color: colorScheme.onSurface.withAlpha((0.07 * 255).toInt()),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    if (doctor != null)
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.medical_services_outlined,
                          title: S().doctor,
                          value:
                              "${S().drPrefix} ${doctor.firstName} ${doctor.lastName}",
                        ),
                      ),
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.schedule_outlined,
                        title: S().started,
                        value: encounter.startTime == null
                            ? "-"
                            : Constant.formatDate(
                                context,
                                encounter.startTime!,
                              ),
                      ),
                    ),
                  ],
                ),
                if (hasReason) ...[
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15.r),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withAlpha(
                        (0.03 * 255).toInt(),
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.notes_outlined,
                          size: 17,
                          color: colorScheme.onSurface.withAlpha(
                            (0.5 * 255).toInt(),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Text(
                            encounter.reason!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withAlpha(
                                (0.7 * 255).toInt(),
                              ),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(9.r),
          decoration: BoxDecoration(
            color: colorScheme.primary.withAlpha((0.08 * 255).toInt()),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, size: 15, color: colorScheme.primary),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withAlpha((0.4 * 255).toInt()),
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
