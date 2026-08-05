import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/profile/models/user_model.dart';

class EncounterNursesPaginationModel {
  final int currentPage;
  final List<EmployeeModel> data;
  final int lastPage;

  EncounterNursesPaginationModel({
    required this.currentPage,
    required this.data,
    required this.lastPage,
  });

  factory EncounterNursesPaginationModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> patientsListJson = json[ApiKey.data];
    return EncounterNursesPaginationModel(
      currentPage: json[ApiKey.currentPage],
      lastPage: json[ApiKey.lastPage],
      data: patientsListJson
          .map((item) => EmployeeModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
