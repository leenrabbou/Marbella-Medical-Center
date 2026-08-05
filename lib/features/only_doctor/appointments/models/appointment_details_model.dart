import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/appointments/models/appointment_model.dart';

class AppointmentDetailsModel {
  final int status;
  final AppointmentModel data;
  final String message;

  AppointmentDetailsModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory AppointmentDetailsModel.fromJson(Map<String, dynamic> jsonData) {
    return AppointmentDetailsModel(
      status: jsonData[ApiKey.status],
      message: jsonData[ApiKey.message],
      data: AppointmentModel.fromJson(jsonData[ApiKey.data]),
    );
  }
}
