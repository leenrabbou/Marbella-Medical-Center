import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/medications/models/medication_model.dart';

class MedicationsListModel {
  final int status;
  final List<MedicationModel> data;
  final String message;

  MedicationsListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory MedicationsListModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> listJson = json[ApiKey.data];
    return MedicationsListModel(
      status: json[ApiKey.status],
      message: json[ApiKey.message],
      data: listJson
          .map((item) => MedicationModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
