import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/observations/models/observation_model.dart';

class ObservationListModel {
  final int status;
  final List<ObservationModel> data;
  final String message;

  ObservationListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ObservationListModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> patientsListJson = json[ApiKey.data];
    return ObservationListModel(
      status: json[ApiKey.status],
      message: json[ApiKey.message],
      data: patientsListJson
          .map(
            (item) => ObservationModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
