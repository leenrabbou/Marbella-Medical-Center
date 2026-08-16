import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/notifications/models/notification_model.dart';

class NotificationListModel {
  final int status;
  final List<NotificationModel> data;
  final String message;

  NotificationListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> patientsListJson = json[ApiKey.data];
    return NotificationListModel(
      status: json[ApiKey.status],
      message: json[ApiKey.message],
      data: patientsListJson
          .map(
            (item) => NotificationModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
