import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/encounters/models/encounters_pagination_model.dart';

class EncountersListModel {
  final int status;
  final EncountersPaginationModel data;
  final String message;

  EncountersListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory EncountersListModel.fromJson(Map<String, dynamic> jsonData) {
    return EncountersListModel(
      status: jsonData[ApiKey.status],
      message: jsonData[ApiKey.message],
      data: EncountersPaginationModel.fromJson(jsonData[ApiKey.data]),
    );
  }
}
