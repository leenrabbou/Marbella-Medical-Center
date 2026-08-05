import 'package:marbella/core/widgets/app_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/features/only_doctor/patients/models/patient_model.dart';
import 'package:marbella/features/only_doctor/patients/views/patient_info_view.dart';
import 'package:marbella/generated/l10n.dart';

class PatientCard extends StatefulWidget {
  const PatientCard({super.key, required this.patient});
  final PatientModel patient;
  @override
  State<PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
  @override
  Widget build(BuildContext context) {
    final bool isMobile = DeviceInfo.isMobile(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PatientInfoView(patient: widget.patient),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black.withAlpha((0.03 * 255).toInt()),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AppAvatar(
              size: 50.r,
              imageUrl: widget.patient.image?.url,
              initials:
                  widget.patient.givenName.substring(0, 1) +
                  widget.patient.familyName.substring(0, 1),
              color:
                  Constant.listColors[(widget.patient.givenName +
                              widget.patient.familyName)
                          .length %
                      Constant.listColors.length],
            ),
            SizedBox(width: isMobile ? 40.w : 20.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.patient.givenName} ${widget.patient.familyName}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    _infoChip(
                      Icons.phone_android_outlined,
                      widget.patient.phoneNumber,
                      colorScheme,
                      theme,
                    ),
                    _infoChip(
                      Icons.cake_outlined,
                      '${Constant.calculateAge(widget.patient.dateOfBirth)} ${S().years_old}',
                      colorScheme,
                      theme,
                    ),
                    _infoChip(
                      Icons.bloodtype_outlined,
                      widget.patient.bloodGroup,
                      colorScheme,
                      theme,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(
    IconData icon,
    String text,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return SizedBox(
      width: 300.w,
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary.withAlpha(100), size: 22),
          SizedBox(width: 8.w),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }
}
