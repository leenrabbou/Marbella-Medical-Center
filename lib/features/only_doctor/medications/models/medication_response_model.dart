import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/medications/models/medication_model.dart';

class MedicationResponseModel {
  final int status;
  final MedicationModel data;
  final String message;

  MedicationResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory MedicationResponseModel.fromJson(Map<String, dynamic> json) {
    return MedicationResponseModel(
      status: json[ApiKey.status],
      message: json[ApiKey.message],
      data: MedicationModel.fromJson(json[ApiKey.data]),
    );
  }
}
