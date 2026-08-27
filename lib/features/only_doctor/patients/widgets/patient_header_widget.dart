import 'package:marbella/core/widgets/app_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/features/only_doctor/patients/models/patient_model.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientHeaderWidget extends StatefulWidget {
  const PatientHeaderWidget({super.key, required this.patient});
  final PatientModel patient;
  @override
  State<PatientHeaderWidget> createState() => _PatientHeaderWidgetState();
}

class _PatientHeaderWidgetState extends State<PatientHeaderWidget> {
  void _launchDialer(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final patient = widget.patient;
    final Color avatarColor =
        Constant.listColors[(patient.givenName.length +
                patient.familyName.length) %
            Constant.listColors.length];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          AppAvatar(
            size: 80.r,
            imageUrl: widget.patient.image?.url,
            initials:
                widget.patient.givenName.substring(0, 1) +
                widget.patient.familyName.substring(0, 1),
            fallbackAsset: widget.patient.gender == "male"
                ? "assets/p_male.png"
                : "assets/pat_f.png",
            color: avatarColor,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${patient.givenName} ${patient.familyName}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3.h),
                _metDots(
                  [
                    '${S().id_label}: ${patient.nationalId}',
                    '${Constant.calculateAge(patient.dateOfBirth)} ${S().years_old}, ${patient.gender}',
                    Constant.formatDate(context, patient.dateOfBirth),
                  ],
                  theme,
                  colorScheme,
                ),
                _metDots(
                  [
                    patient.occupation,
                    Constant.parseMaritalStatus(patient.maritalStatus),
                  ],
                  theme,
                  colorScheme,
                ),
              ],
            ),
          ),
          _phoneChip(
            patient.phoneNumber,
            colorScheme.primary,
            theme,
            colorScheme,
            () => _launchDialer(patient.phoneNumber),
          ),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }

  Widget _metDots(
    List<String> items,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final style = theme.textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurface.withAlpha((0.7 * 255).toInt()),
    );
    final dotStyle = theme.textTheme.titleLarge?.copyWith(
      color: colorScheme.onSurface.withAlpha(80),
    );
    return Wrap(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Text(items[i], style: style),
          if (i < items.length - 1)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(' • ', style: dotStyle),
            ),
        ],
      ],
    );
  }

  Widget _phoneChip(
    String phone,
    Color color,
    ThemeData theme,
    ColorScheme colorScheme,
    VoidCallback onTap,
  ) {
    return Semantics(
      button: true,
      label: '${S().phone_label} $phone',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: colorScheme.onSurface.withAlpha((0.05 * 255).toInt()),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: color.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.phone_android_outlined,
                  size: 18,
                  color: color,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S().phone_label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    phone,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10.w),
              Icon(Icons.arrow_forward_ios_rounded, size: 12, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
