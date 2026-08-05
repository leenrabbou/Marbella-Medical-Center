import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/patients/models/patient_model.dart';

class PatientResponseModel {
  final int status;
  final String message;
  final PatientModel data;
  PatientResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });
  factory PatientResponseModel.fromJson(Map<String, dynamic> json) {
    return PatientResponseModel(
      status: json[ApiKey.status],
      message: json[ApiKey.message],
      data: PatientModel.fromJson(json[ApiKey.data]),
    );
  }
}
