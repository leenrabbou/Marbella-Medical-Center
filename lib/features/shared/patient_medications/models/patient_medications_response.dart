import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/patient_medications/models/patient_medication_model.dart';

class PatientMedicationsResponse {
  final int status;
  final PatientMedicationModel data;
  final String message;
  PatientMedicationsResponse({
    required this.status,
    required this.data,
    required this.message,
  });
  factory PatientMedicationsResponse.fromJson(Map<String, dynamic> json) {
    return PatientMedicationsResponse(
      status: json[ApiKey.status],
      message: json[ApiKey.message],
      data: PatientMedicationModel.fromJson(json[ApiKey.data]),
    );
  }
}
