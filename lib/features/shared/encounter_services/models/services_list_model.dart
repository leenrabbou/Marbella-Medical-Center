import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/appointments/models/service_model.dart';

class ServicesListModel {
  final int status;
  final List<ServiceModel> data;
  final String message;

  ServicesListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ServicesListModel.fromJson(Map<String, dynamic> jsonData) {
    return ServicesListModel(
      status: jsonData[ApiKey.status],
      message: jsonData[ApiKey.message],
      data: List.from(
        jsonData[ApiKey.data],
      ).map((val) => ServiceModel.fromJson(val)).toList(),
    );
  }
}
