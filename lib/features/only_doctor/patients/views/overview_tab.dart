import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/conditions/viewmodels/condition_viewmodel.dart';
import 'package:marbella/features/shared/patient_medications/viewmodel/patient_medication_viewmodel.dart';
import 'package:marbella/features/only_doctor/patients/widgets/active_conditions_card.dart';
import 'package:marbella/features/only_doctor/patients/widgets/active_medications_card.dart';
import 'package:marbella/features/only_doctor/patients/widgets/brief_card.dart';
import 'package:marbella/features/only_doctor/patients/widgets/info_card.dart';
import 'package:marbella/features/only_doctor/patients/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/features/only_doctor/appointments/viewmodels/appointments_viewmodel.dart';
import 'package:marbella/features/only_doctor/appointments/views/appointment_details_view.dart';
import 'package:marbella/features/shared/encounters/views/encounter_details_view.dart';
import 'package:marbella/features/shared/encounters/viewmodels/encounter_viewmodel.dart';
import 'package:marbella/features/only_doctor/patients/models/patient_model.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key, required this.patient});
  final PatientModel patient;
  @override
  Widget build(BuildContext context) {
    final encounterProvider = context.watch<EncounterViewmodel>();
    final appointmentProvider = context.watch<AppointmentsViewmodel>();
    final patientMedicationProvider = context
        .watch<PatientMedicationViewmodel>();
    final conditionProvider = context.watch<ConditionViewmodel>();
    final colorScheme = Theme.of(context).colorScheme;
    bool isTablet = DeviceInfo.isTablet(context);
    final encounters = encounterProvider.allEncounters;
    final appointments = appointmentProvider.getAppointmentsListByStatus(
      'booked',
    );
    final medicationParams = PatientMedicationsParams(
      patientId: patient.id,
      doctorId: null,
      encounterId: null,
      status: 'active',
    );
    final medications = patientMedicationProvider.medicationsFor(
      medicationParams,
    );
    final conditionParams = ConditionParams(
      encounterId: null,
      clinicalStatus: 'active',
      verificationStatus: null,
      patientId: patient.id,
    );
    final conditions = conditionProvider.conditionsFor(conditionParams);
    final lastEncounter = encounters.isNotEmpty ? encounters.first : null;
    final nextApp = appointments.isNotEmpty ? appointments.first : null;
    if (encounterProvider.isLoading) {
      return Center(
        child: SpinKitFoldingCube(color: colorScheme.primary, size: 20),
      );
    }
    if (appointmentProvider.isLoading) {
      return Center(
        child: SpinKitFoldingCube(color: colorScheme.primary, size: 20),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: DeviceInfo.isTablet(context) ? 4 : 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          mainAxisExtent: isTablet ? 230.h : 180.h,
        ),
        children: [
          SummaryCard(
            encounterCount: encounters.length,
            conditionsCount: conditions.length,
            medicationCount: medications.length,
          ),
          BriefCard(
            title: S().last_encounter,
            date: lastEncounter?.startTime != null
                ? Constant.formatDate(context, lastEncounter!.startTime!)
                : '—',
            text: lastEncounter?.reason ?? S().no_records_yet,
            btnTtext: lastEncounter == null ? '—' : S().view_details,
            imagePath: 'assets/stethoscope.jpg',
            onTap: () {
              lastEncounter != null
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EncounterDetailsView(encounter: lastEncounter),
                      ),
                    )
                  : null;
            },
          ),
          BriefCard(
            title: S().next_appointment,
            date: nextApp?.startTime != null
                ? Constant.formatDate(context, nextApp!.startTime)
                : '—',
            text: nextApp?.reason ?? S().no_records_yet,
            btnTtext: nextApp == null ? '—' : S().view_appointment,
            imagePath: 'assets/OIP (2).webp',
            onTap: () {
              nextApp != null
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AppointmentDetailsView(
                          appointment: nextApp,
                          isFromPatient: false,
                        ),
                      ),
                    )
                  : null;
            },
          ),
          InfoCard(patient: patient),
          ActiveMedicationsCard(patientId: patient.id),
          ActiveConditionsCard(patientId: patient.id),
        ],
      ),
    );
  }
}
