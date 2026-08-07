import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/features/only_doctor/medications/models/conflict_interaction.dart';

class ConflictError extends ErrorModel {
  final List<ConflictInteraction> interactions;

  ConflictError({
    required super.status,
    required super.errorMessage,
    required this.interactions,
  });
}
