import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/schedule/models/schedule_model.dart';

class ScheduleResponseModel {
  final int status;
  final List<ScheduleModel> data;
  final String message;
  ScheduleResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });
  factory ScheduleResponseModel.fromJson(Map<String, dynamic> jsonData) {
    return ScheduleResponseModel(
      status: jsonData[ApiKey.status],
      message: jsonData[ApiKey.message],
      data: List.from(
        jsonData[ApiKey.data],
      ).map((val) => ScheduleModel.fromJson(val)).toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      ApiKey.status: status,
      ApiKey.data: data.map((model) => model.toJson()).toList(),
      ApiKey.message: message,
    };
  }
}
