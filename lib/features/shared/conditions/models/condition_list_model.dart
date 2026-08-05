import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/conditions/models/condition_model.dart';

class ConditionListModel {
  final int status;
  final List<ConditionModel> data;
  final String message;

  ConditionListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ConditionListModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> patientsListJson = json[ApiKey.data];
    return ConditionListModel(
      status: json[ApiKey.status],
      message: json[ApiKey.message],
      data: patientsListJson
          .map((item) => ConditionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
