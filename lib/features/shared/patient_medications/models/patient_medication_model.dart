import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/medications/models/medication_model.dart';

class PatientMedicationModel {
  final int id;
  final int patientId;
  final int encounterId;
  final MedicationModel medication;
  final String dosage;
  final String route;
  final int durationValue;
  final String durationUnit;
  final String? untilDate;
  final String? notes;
  PatientMedicationModel({
    required this.id,
    required this.patientId,
    required this.encounterId,
    required this.medication,
    required this.dosage,
    required this.durationUnit,
    required this.durationValue,
    required this.notes,
    required this.route,
    required this.untilDate,
  });
  factory PatientMedicationModel.fromJson(Map<String, dynamic> json) {
    return PatientMedicationModel(
      id: json[ApiKey.id],
      patientId: json[ApiKey.patientId],
      encounterId: json[ApiKey.encounterId],
      medication: MedicationModel.fromJson(json[ApiKey.medication]),
      dosage: json[ApiKey.dosage],
      durationUnit: json[ApiKey.durationUnit],
      durationValue: json[ApiKey.durationValue],
      notes: json[ApiKey.notes],
      route: json[ApiKey.route],
      untilDate: json[ApiKey.untilDate],
    );
  }
}
