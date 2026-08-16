import 'package:flutter/foundation.dart';
import 'package:marbella/features/shared/notifications/models/notification_model.dart';
import 'package:marbella/features/shared/notifications/service/notifications_service.dart';

class NotificationViewmodel extends ChangeNotifier {
  final NotificationService notificationService;

  NotificationViewmodel({required this.notificationService});

  bool isLoading = false;
  bool isMarkingAll = false;
  String? errorMessage;
  List<NotificationModel> notifications = [];

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications(String token, String locale) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await notificationService.getNotifications(locale, token);
    result.fold(
      (failure) => errorMessage = failure.errorMessage,
      (data) => notifications = data.data,
    );

    isLoading = false;
    notifyListeners();
  }

  Future<void> markAll(String token, String locale) async {
    isMarkingAll = true;
    notifyListeners();

    final result = await notificationService.markAll(locale, token);
    result.fold((failure) => errorMessage = failure.errorMessage, (_) {
      notifications = notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
    });

    isMarkingAll = false;
    notifyListeners();
  }

  void markOneAsRead(String localKey) {
    final index = notifications.indexWhere((n) => n.localKey == localKey);
    if (index == -1 || notifications[index].isRead) return;
    notifications[index] = notifications[index].copyWith(isRead: true);
    notifyListeners();
  }

  void addRealtimeNotification(NotificationModel notification) {
    final exists = notifications.any(
      (n) => n.localKey == notification.localKey,
    );
    if (exists) return;
    notifications.insert(0, notification);
    notifyListeners();
  }
}
