import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/appointments/models/appointment_model.dart';

class AppointmentsListModel {
  final int status;
  final List<AppointmentModel> data;
  final String message;

  AppointmentsListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory AppointmentsListModel.fromJson(Map<String, dynamic> jsonData) {
    return AppointmentsListModel(
      status: jsonData[ApiKey.status],
      message: jsonData[ApiKey.message],
      data: List.from(
        jsonData[ApiKey.data],
      ).map((val) => AppointmentModel.fromJson(val)).toList(),
    );
  }
}
