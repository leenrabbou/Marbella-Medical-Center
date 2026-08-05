import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/patients/models/patient_model.dart';

class PatientsPaginationModel {
  final int currentPage;
  final List<PatientModel> data;
  final int lastPage;
  PatientsPaginationModel({
    required this.currentPage,
    required this.data,
    required this.lastPage,
  });
  factory PatientsPaginationModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> patientsListJson = json[ApiKey.data];
    return PatientsPaginationModel(
      currentPage: json[ApiKey.currentPage],
      lastPage: json[ApiKey.lastPage],
      data: patientsListJson
          .map((item) => PatientModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
