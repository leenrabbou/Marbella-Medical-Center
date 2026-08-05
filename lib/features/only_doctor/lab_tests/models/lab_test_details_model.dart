import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/lab_tests/models/lab_test_model.dart';

class LabTestDetailsModel {
  final LabTestModel data;

  LabTestDetailsModel({required this.data});

  factory LabTestDetailsModel.fromJson(Map<String, dynamic> jsonData) {
    return LabTestDetailsModel(
      data: LabTestModel.fromJson(jsonData[ApiKey.data]),
    );
  }
}
