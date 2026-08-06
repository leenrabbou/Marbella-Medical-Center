import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/features/only_doctor/medications/models/drug_interaction_model.dart';

class ConflictError extends ErrorModel {
  final List<DrugInteractionModel> interactions;

  ConflictError({
    required super.status,
    required super.errorMessage,
    required this.interactions,
  });
}
