import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/patients/models/index/patients_pagination_model.dart';

class PatientsListModel {
  final int status;
  final PatientsPaginationModel data;
  final String message;
  PatientsListModel({
    required this.status,
    required this.data,
    required this.message,
  });
  factory PatientsListModel.fromJson(Map<String, dynamic> jsonData) {
    return PatientsListModel(
      status: jsonData[ApiKey.status],
      message: jsonData[ApiKey.message],
      data: PatientsPaginationModel.fromJson(jsonData[ApiKey.data]),
    );
  }
}
