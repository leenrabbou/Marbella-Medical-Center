import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/nurses/models/encounter_nurses_pagination_model.dart';

class EncounterNursesListModel {
  final int status;
  final EncounterNursesPaginationModel data;
  final String message;

  EncounterNursesListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory EncounterNursesListModel.fromJson(Map<String, dynamic> jsonData) {
    return EncounterNursesListModel(
      status: jsonData[ApiKey.status],
      message: jsonData[ApiKey.message],
      data: EncounterNursesPaginationModel.fromJson(jsonData[ApiKey.data]),
    );
  }
}
