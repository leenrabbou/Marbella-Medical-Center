import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/encounter_services/models/encounter_service_model.dart';

class EncounterServicesListModel {
  final int status;
  final List<EncounterServiceModel> data;
  final String message;

  EncounterServicesListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory EncounterServicesListModel.fromJson(Map<String, dynamic> jsonData) {
    return EncounterServicesListModel(
      status: jsonData[ApiKey.status],
      message: jsonData[ApiKey.message],
      data: List.from(
        jsonData[ApiKey.data],
      ).map((val) => EncounterServiceModel.fromJson(val)).toList(),
    );
  }
}
