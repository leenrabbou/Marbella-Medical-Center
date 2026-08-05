import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/encounters/models/encounter_model.dart';

class EncountersPaginationModel {
  final int currentPage;
  final List<EncounterModel> data;
  final int lastPage;

  EncountersPaginationModel({
    required this.currentPage,
    required this.data,
    required this.lastPage,
  });

  factory EncountersPaginationModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> patientsListJson = json[ApiKey.data];
    return EncountersPaginationModel(
      currentPage: json[ApiKey.currentPage],
      lastPage: json[ApiKey.lastPage],
      data: patientsListJson
          .map((item) => EncounterModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
