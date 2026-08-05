import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/encounters/models/encounter_model.dart';

class EncounterResponseModel {
  final int status;
  final EncounterModel data;
  final String message;

  EncounterResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory EncounterResponseModel.fromJson(Map<String, dynamic> json) {
    return EncounterResponseModel(
      status: json[ApiKey.status],
      message: json[ApiKey.message],
      data: EncounterModel.fromJson(json[ApiKey.data]),
    );
  }
}
