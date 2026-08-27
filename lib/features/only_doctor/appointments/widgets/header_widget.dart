import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/features/only_doctor/appointments/models/appointment_model.dart';
import 'package:marbella/features/only_doctor/patients/views/patient_info_view.dart';
import 'package:marbella/generated/l10n.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.appointment,
    required this.imgBytes,
    required this.isFromPatient,
  });

  final AppointmentModel appointment;
  final Uint8List? imgBytes;
  final bool isFromPatient;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 30.r,
          backgroundColor: Colors.white.withAlpha(50),
          backgroundImage: imgBytes != null
              ? MemoryImage(imgBytes!)
              : (appointment.patient.image != null
                    ? NetworkImage(appointment.patient.image!.url)
                    : null),
          child: imgBytes == null && appointment.patient.image == null
              ? Text(
                  appointment.patient.givenName.substring(0, 1) +
                      appointment.patient.familyName.substring(0, 1),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                )
              : null,
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${appointment.patient.givenName} ${appointment.patient.familyName}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6.h),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _headerChip(
                    context,
                    Icons.cake_outlined,

                    '${Constant.calculateAge(appointment.patient.dateOfBirth)} ${S().years_old}',
                  ),
                  _headerChip(
                    context,
                    appointment.patient.gender == 'male'
                        ? Icons.male
                        : Icons.female,
                    appointment.patient.gender,
                  ),
                  _headerChip(
                    context,
                    Icons.water_drop_outlined,
                    appointment.patient.bloodGroup,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isFromPatient)
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PatientInfoView(
                  patient: appointment.patient,
                ),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
      ],
    );
  }

  Widget _headerChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(35),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          SizedBox(width: 5.w),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
