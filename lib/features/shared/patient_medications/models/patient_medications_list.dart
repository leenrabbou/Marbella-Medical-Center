import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/patient_medications/models/patient_medication_model.dart';

class PatientMedicationsList {
  final int status;
  final List<PatientMedicationModel> data;
  final String message;
  PatientMedicationsList({
    required this.status,
    required this.data,
    required this.message,
  });
  factory PatientMedicationsList.fromJson(Map<String, dynamic> json) {
    final List<dynamic> patientsListJson = json[ApiKey.data];
    return PatientMedicationsList(
      status: json[ApiKey.status],
      message: json[ApiKey.message],
      data: patientsListJson
          .map(
            (item) =>
                PatientMedicationModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
