import 'package:marbella/features/only_doctor/medications/models/condition_interaction_model.dart';
import 'package:marbella/features/only_doctor/medications/models/drug_interaction_model.dart';

enum ConflictType { medication, condition }

class ConflictInteraction {
  final int id;
  final int medicationId;
  final String severity;
  final String? description;
  final ConflictType type;
  final String displayName;

  ConflictInteraction._({
    required this.id,
    required this.medicationId,
    required this.severity,
    required this.description,
    required this.type,
    required this.displayName,
  });

  factory ConflictInteraction.fromDrug(DrugInteractionModel m) {
    return ConflictInteraction._(
      id: m.id,
      medicationId: m.medicationId,
      severity: m.severity,
      description: m.description,
      type: ConflictType.medication,
      displayName: m.drugInteraction.code.display,
    );
  }

  factory ConflictInteraction.fromCondition(ConditionInteractionModel m) {
    return ConflictInteraction._(
      id: m.id,
      medicationId: m.medicationId,
      severity: m.severity,
      description: m.description,
      type: ConflictType.condition,
      displayName: m.conditionInteraction.display,
    );
  }
}
