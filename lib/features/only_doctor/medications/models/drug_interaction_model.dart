import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/medications/models/medication_model.dart';

class DrugInteractionModel {
  final int id;
  final int medicationId;
  final String severity;
  final String? description;
  final MedicationModel drugInteraction;

  DrugInteractionModel({
    required this.id,
    required this.medicationId,
    required this.severity,
    required this.description,
    required this.drugInteraction,
  });

  factory DrugInteractionModel.fromJson(Map<String, dynamic> json) {
    return DrugInteractionModel(
      id: json[ApiKey.id],
      medicationId: json[ApiKey.medicationId],
      severity: json[ApiKey.severity],
      description: json[ApiKey.description],
      drugInteraction: MedicationModel.fromJson(json[ApiKey.drugInteraction]),
    );
  }
}
