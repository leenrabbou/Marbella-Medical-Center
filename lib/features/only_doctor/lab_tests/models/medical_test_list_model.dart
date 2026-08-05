import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/lab_tests/models/medical_test_model.dart';

class MedicalTestListModel {
  final List<MedicalTestModel> data;

  MedicalTestListModel({required this.data});

  factory MedicalTestListModel.fromJson(Map<String, dynamic> jsonData) {
    return MedicalTestListModel(
      data: (jsonData[ApiKey.data] as List)
          .map((e) => MedicalTestModel.fromJson(e))
          .toList(),
    );
  }
}
