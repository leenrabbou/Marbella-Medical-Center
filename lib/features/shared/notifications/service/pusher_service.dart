import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/features/only_doctor/chat/Models/conversation_model.dart';
import 'package:marbella/features/only_doctor/chat/Models/message_model.dart';
import 'package:marbella/features/only_doctor/chat/viewmodel/chat_viewmodel.dart';
import 'package:marbella/features/shared/notifications/models/notification_model.dart';
import 'package:marbella/features/shared/notifications/service/notifications_service.dart';
import 'package:marbella/features/shared/settings/viewmodels/localization_viewmodel.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  ApiServices apiService;
  PusherService({required this.apiService});
  final pusher = PusherChannelsFlutter.getInstance();
  int notificationID = 0;

  Future<void> initPusher(int userId, {ChatViewmodel? chatViewmodel}) async {
    bool isArabic = LocalizationViewmodel.isArabic();
    final String notificationsChannel = 'User.$userId';
    final String messagesChannel = 'User.$userId.Message';

    try {
      await pusher.init(
        apiKey: '461f10be7b84c1ef6776',
        cluster: 'eu',
        onConnectionStateChange: (previousState, currentState) {
          if (kDebugMode) {
            print("Connection changed: $previousState → $currentState");
          }
        },
        onError: (message, code, exception) {
          if (kDebugMode) {
            print("Error: $message | code: $code | exception: $exception");
          }
        },
        onSubscriptionSucceeded: (channelName, data) {
          if (kDebugMode) {
            print("✅ Subscribed to $channelName");
          }
        },
        onEvent: (event) async {
          if (kDebugMode) {
            print(
              "📩 Event: ${event.eventName} on ${event.channelName} -> ${event.data}",
            );
          }
          try {
            final Map<String, dynamic> parsedData = jsonDecode(event.data);

            final isChatChannel = event.channelName == messagesChannel;

            if (isChatChannel && event.eventName == 'message.sent') {
              final conversationId = parsedData['conversation_id'] as int;
              final message = MessageModel.fromJson(
                parsedData['message'] ?? parsedData,
              );
              chatViewmodel?.receiveIncomingMessage(conversationId, message);

              if (message.isSender != 1) {
                ConversationModel? conversation;
                if (chatViewmodel != null) {
                  for (final c in chatViewmodel.conversations) {
                    if (c.id == conversationId) {
                      conversation = c;
                      break;
                    }
                  }
                }

                final senderName = conversation != null
                    ? '${conversation.patient.givenName} ${conversation.patient.familyName}'
                          .trim()
                    : (isArabic ? 'رسالة جديدة' : 'New Message');

                final bodyText = message.attachments.isNotEmpty
                    ? (isArabic ? 'أرسل مرفق' : 'Sent an attachment')
                    : message.body;

                await NotificationService(
                  apiService: apiService,
                ).showNotification(
                  id: notificationID,
                  title: senderName,
                  body: bodyText,
                );
                notificationID++;
              }
              return;
            }

            if (event.channelName == notificationsChannel &&
                event.eventName == 'notification') {
              NotificationModel receivedNotification =
                  NotificationModel.fromJson(parsedData);

              await NotificationService(
                apiService: apiService,
              ).showNotification(
                id: notificationID,
                title: isArabic
                    ? receivedNotification.titleAr
                    : receivedNotification.titleEn,
                body: isArabic
                    ? receivedNotification.bodyAr
                    : receivedNotification.bodyEn,
              );

              if (kDebugMode) {
                print("✅ Notification shown with id: $notificationID");
              }
              notificationID++;
              return;
            }

            if (kDebugMode) {
              print(
                "ℹ️ Unhandled event: ${event.eventName} on ${event.channelName}",
              );
            }
          } catch (e, st) {
            if (kDebugMode) {
              print("❌ Failed to handle event: $e");
              print(st);
            }
          }
        },
        onSubscriptionError: (channelName, message) {
          if (kDebugMode) {
            print("❌ Subscription error in $channelName : $message");
          }
        },
        onDecryptionFailure: (event, reason) {
          if (kDebugMode) {
            print("Decryption failed for $event : $reason");
          }
        },
        onMemberAdded: (channelName, member) {
          if (kDebugMode) {
            print("👤 Member added in $channelName: ${member.userId}");
          }
        },
        onMemberRemoved: (channelName, member) {
          if (kDebugMode) {
            print("👋 Member removed in $channelName: ${member.userId}");
          }
        },
      );

      await pusher.subscribe(channelName: notificationsChannel);
      await pusher.subscribe(channelName: messagesChannel);

      await pusher.connect();
    } catch (e) {
      if (kDebugMode) {
        print("ERROR: $e");
      }
    }
  }
}
