import 'package:marbella/core/databases/api/end_points.dart';

class NotificationModel {
  String titleEn;
  String titleAr;
  String bodyEn;
  String bodyAr;
  bool isRead;

  NotificationModel({
    required this.titleEn,
    required this.titleAr,
    required this.bodyAr,
    required this.bodyEn,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> jsonData) {
    return NotificationModel(
      titleEn: jsonData[ApiKey.titleEn] ?? '',
      titleAr: jsonData[ApiKey.titleAr] ?? '',
      bodyAr: jsonData[ApiKey.bodyAr] ?? '',
      bodyEn: jsonData[ApiKey.bodyEn] ?? '',
    );
  }

  String get localKey => '$titleEn|$bodyEn';

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      titleEn: titleEn,
      titleAr: titleAr,
      bodyAr: bodyAr,
      bodyEn: bodyEn,
      isRead: isRead ?? this.isRead,
    );
  }

  String title(bool isArabic) => isArabic ? titleAr : titleEn;
  String body(bool isArabic) => isArabic ? bodyAr : bodyEn;
}
