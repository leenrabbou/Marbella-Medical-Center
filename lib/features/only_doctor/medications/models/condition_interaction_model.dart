import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/codes/models/code_model.dart';

class ConditionInteractionModel {
  final int id;
  final int medicationId;
  final String severity;
  final String? description;
  final CodeModel conditionInteraction;

  ConditionInteractionModel({
    required this.id,
    required this.medicationId,
    required this.severity,
    required this.description,
    required this.conditionInteraction,
  });
  factory ConditionInteractionModel.fromJson(Map<String, dynamic> json) {
    return ConditionInteractionModel(
      id: json[ApiKey.id],
      medicationId: json[ApiKey.medicationId],
      severity: json[ApiKey.severity],
      description: json[ApiKey.description],
      conditionInteraction: CodeModel.fromJson(
        json[ApiKey.conditionInteraction],
      ),
    );
  }
}
