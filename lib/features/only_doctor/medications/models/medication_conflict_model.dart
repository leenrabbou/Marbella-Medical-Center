import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/medications/models/condition_interaction_model.dart';
import 'package:marbella/features/only_doctor/medications/models/conflict_interaction.dart';
import 'package:marbella/features/only_doctor/medications/models/drug_interaction_model.dart';

class MedicationConflictModel {
  final int status;
  final String message;
  final List<ConflictInteraction> interactions;

  MedicationConflictModel({
    required this.status,
    required this.message,
    required this.interactions,
  });

  factory MedicationConflictModel.fromJson(Map<String, dynamic> json) {
    final dataMap = json[ApiKey.data];
    if (dataMap == null || dataMap is! Map) {
      throw FormatException('Expected data to be a Map, got: $dataMap');
    }

    final List<ConflictInteraction> items = [];

    final medications = dataMap[ApiKey.medications];
    if (medications is List) {
      items.addAll(
        medications
            .whereType<Map>()
            .map(
              (e) =>
                  DrugInteractionModel.fromJson(Map<String, dynamic>.from(e)),
            )
            .map(ConflictInteraction.fromDrug),
      );
    }

    final conditions = dataMap[ApiKey.conditions];
    if (conditions is List) {
      items.addAll(
        conditions
            .whereType<Map>()
            .map(
              (e) => ConditionInteractionModel.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .map(ConflictInteraction.fromCondition),
      );
    }

    return MedicationConflictModel(
      status: json[ApiKey.status],
      message: json[ApiKey.message],
      interactions: items,
    );
  }
}
