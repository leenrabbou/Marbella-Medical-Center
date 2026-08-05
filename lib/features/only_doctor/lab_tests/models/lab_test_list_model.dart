import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/lab_tests/models/lab_test_model.dart';

class LabTestListModel {
  final List<LabTestModel> data;
  final int currentPage;
  final int lastPage;

  LabTestListModel({
    required this.data,
    required this.currentPage,
    required this.lastPage,
  });

  factory LabTestListModel.fromJson(Map<String, dynamic> jsonData) {
    final paginated = jsonData[ApiKey.data];
    return LabTestListModel(
      data: (paginated[ApiKey.data] as List)
          .map((e) => LabTestModel.fromJson(e))
          .toList(),
      currentPage: paginated[ApiKey.currentPage],
      lastPage: paginated[ApiKey.lastPage],
    );
  }
}
