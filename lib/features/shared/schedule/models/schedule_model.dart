import 'package:marbella/core/databases/api/end_points.dart';

class ScheduleModel {
  int id;
  String dayOfWeek;
  String? startTime;
  String? endTime;
  int slotDuration;
  bool isActive;
  ScheduleModel({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.slotDuration,
    required this.isActive,
  });
  factory ScheduleModel.fromJson(Map<String, dynamic> jsonData) {
    return ScheduleModel(
      id: jsonData[ApiKey.id],
      dayOfWeek: jsonData[ApiKey.dayOfWeek],
      startTime: jsonData[ApiKey.startTime],
      endTime: jsonData[ApiKey.endTime],
      slotDuration: jsonData[ApiKey.slotDuration],
      isActive: jsonData[ApiKey.isActive],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      ApiKey.id: id,
      ApiKey.dayOfWeek: dayOfWeek,
      ApiKey.startTime: startTime,
      ApiKey.endTime: endTime,
      ApiKey.slotDuration: slotDuration,
      ApiKey.isActive: isActive,
    };
  }
}
