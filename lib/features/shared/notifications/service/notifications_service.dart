import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dartz/dartz.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/features/shared/notifications/models/notification_list_model.dart';

class NotificationService {
  final ApiServices apiService;
  NotificationService({required this.apiService});
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  NotificationDetails notificationDetails({Color? color}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id1',
        'Daily Notifications',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
        // sound: RawResourceAndroidNotificationSound('noti_sound'),
        color: color,
      ),
      // iOS: DarwinNotificationDetails(sound: 'noti_sound.aiff'),
    );
  }

  Future<void> initNotification() async {
    if (_isInitialized) return;

    const initAndroidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initIOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: initAndroidSettings,
      iOS: initIOSSettings,
    );

    await notificationPlugin.initialize(initSettings);

    final granted = await notificationPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    if (kDebugMode) {
      print('🔔 Notification permission granted: $granted');
    }

    _isInitialized = true;
  }

  Future<void> showNotification({
    required int id,
    String? title,
    String? body,
  }) async {
    return notificationPlugin.show(id, title, body, notificationDetails());
  }

  Future<Either<ErrorModel, NotificationListModel>> getNotifications(
    String locale,
    String? token,
  ) async {
    try {
      String url = EndPoints.notifications;
      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );

      if (response[ApiKey.status] == 1) {
        final data = NotificationListModel.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> markAll(String locale, String? token) async {
    try {
      String url = EndPoints.notifications;
      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );

      if (response[ApiKey.status] == 1) {
        return Right(null);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }
}
