import 'dart:io';

import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/chat/Models/conversation_model.dart';
import 'package:marbella/features/only_doctor/chat/Models/message_model.dart';
import 'package:marbella/features/only_doctor/chat/service/chat_service.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/foundation.dart';

class ChatViewmodel extends ChangeNotifier {
  ChatService chatService;
  final NetworkInfo networkInfo;

  ChatViewmodel({required this.chatService, required this.networkInfo});

  bool isLoadingConversations = false;
  bool isLoadingConversationsMore = false;
  String? conversationsErrorMessage;
  List<ConversationModel> conversations = [];
  int _currentPageConversations = 1;
  bool hasMoreConversations = true;

  bool isLoadingMessages = false;
  bool isLoadingMessagesMore = false;
  String? messagesErrorMessage;
  List<MessageModel> messages = [];
  int _currentPageMessages = 1;
  bool hasMoreMessages = true;

  bool addIsLoading = false;
  String? addErrorMessage;
  static const int maxAttachmentBytes = 5 * 1024 * 1024;

  Future<void> getConversations(String locale, String? token) async {
    isLoadingConversations = true;
    conversationsErrorMessage = null;
    conversations = [];
    _currentPageConversations = 1;
    hasMoreConversations = true;
    notifyListeners();

    if (token == null) {
      conversationsErrorMessage = S().token_missing;
      isLoadingConversations = false;
      notifyListeners();
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      conversationsErrorMessage = S().no_internet_message;
      isLoadingConversations = false;
      notifyListeners();
      return;
    }

    final result = await chatService.getConversations(
      locale,
      token,
      _currentPageConversations,
    );

    result.fold(
      (failure) {
        conversationsErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("failed fetch all Conversations: ${failure.errorMessage}");
        }
      },
      (response) {
        conversations = response.data.data;
        hasMoreConversations =
            response.data.currentPage < response.data.lastPage;
        if (kDebugMode) print("fetch all Conversations success");
      },
    );

    isLoadingConversations = false;
    notifyListeners();
  }

  Future<void> getMessages(
    String locale,
    String? token,
    int conversationId,
  ) async {
    isLoadingMessages = true;
    messagesErrorMessage = null;
    messages = [];
    _currentPageMessages = 1;
    hasMoreMessages = true;
    notifyListeners();

    if (token == null) {
      messagesErrorMessage = S().token_missing;
      isLoadingMessages = false;
      notifyListeners();
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      messagesErrorMessage = S().no_internet_message;
      isLoadingMessages = false;
      notifyListeners();
      return;
    }

    final result = await chatService.getMessages(
      locale,
      token,
      _currentPageMessages,
      conversationId,
    );

    result.fold(
      (failure) {
        messagesErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("failed fetch all Messages: ${failure.errorMessage}");
        }
      },
      (response) {
        messages = response.data.data;
        hasMoreMessages = response.data.currentPage < response.data.lastPage;
        if (kDebugMode) print("fetch all Messages success");
      },
    );

    isLoadingMessages = false;
    notifyListeners();
  }

  bool isLoadingMoreMessages = false;

  Future<void> loadMoreMessages(
    String locale,
    String? token,
    int conversationId,
  ) async {
    if (!hasMoreMessages || isLoadingMoreMessages || isLoadingMessages) return;
    if (token == null) return;

    isLoadingMoreMessages = true;
    notifyListeners();

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      isLoadingMoreMessages = false;
      notifyListeners();
      return;
    }

    final nextPage = _currentPageMessages + 1;

    final result = await chatService.getMessages(
      locale,
      token,
      nextPage,
      conversationId,
    );

    result.fold(
      (failure) {
        if (kDebugMode) {
          print("failed fetch more Messages: ${failure.errorMessage}");
        }
      },
      (response) {
        messages = [...messages, ...response.data.data];
        _currentPageMessages = response.data.currentPage;
        hasMoreMessages = response.data.currentPage < response.data.lastPage;
        if (kDebugMode) print("fetch more Messages success");
      },
    );

    isLoadingMoreMessages = false;
    notifyListeners();
  }

  void markConversationAsRead(int conversationId) {
    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      conversations[index] = conversations[index].copyWith(unreadCount: 0);
      notifyListeners();
    }
  }

  String _resolveBody(String text, List<File> attachments) {
    final trimmed = text.trim();
    if (trimmed.isNotEmpty || attachments.isEmpty) return trimmed;
    final ext = attachments.first.path.split('.').last.toLowerCase();
    final isImage = ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
    return isImage ? S().image : attachments.first.path.split('/').last;
  }

  Future<bool> sendMessage(
    String text,
    List<File> attachments,
    String locale,
    String? token,
    int conversationId,
  ) async {
    for (final file in attachments) {
      final size = await file.length();
      if (size > maxAttachmentBytes) {
        addErrorMessage = 'حجم الملف أكبر من 5 ميغابايت';
        notifyListeners();
        return false;
      }
    }

    final resolvedText = _resolveBody(text, attachments);
    final tempId = -DateTime.now().millisecondsSinceEpoch;
    final now = DateTime.now();

    final optimisticMessage = MessageModel(
      id: tempId,
      type: attachments.isNotEmpty ? 'attachment' : 'text',
      body: resolvedText,
      isSeen: 0,
      isSender: 1,
      sentAt: now.toIso8601String(),
      readAt: null,
      attachments: const [],
      localStatus: MessageLocalStatus.sending,
    );

    messages.insert(0, optimisticMessage);
    _syncConversationPreview(conversationId, optimisticMessage, now);
    notifyListeners();

    if (token == null) {
      _markFailed(tempId, conversationId);
      return false;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      addErrorMessage = S().no_internet_message;
      _markFailed(tempId, conversationId);
      return false;
    }

    final params = MessageParams(
      message: resolvedText,
      attachments: attachments,
    );
    final result = await chatService.sendMessage(
      locale,
      token,
      params,
      conversationId,
    );

    return result.fold(
      (failure) {
        addErrorMessage = failure.errorMessage;
        _markFailed(tempId, conversationId);
        return false;
      },
      (serverMessage) {
        final index = messages.indexWhere((m) => m.id == tempId);
        final finalMessage =
            serverMessage ??
            optimisticMessage.copyWith(localStatus: MessageLocalStatus.sent);

        if (index != -1) {
          messages[index] = finalMessage;
        }
        _syncConversationPreview(conversationId, finalMessage, now);
        notifyListeners();
        return true;
      },
    );
  }

  void _markFailed(int tempId, int conversationId) {
    final index = messages.indexWhere((m) => m.id == tempId);
    if (index != -1) {
      final failedMessage = messages[index].copyWith(
        localStatus: MessageLocalStatus.failed,
      );
      messages[index] = failedMessage;
      _syncConversationPreview(conversationId, failedMessage, DateTime.now());
    }
    notifyListeners();
  }

  void _syncConversationPreview(
    int conversationId,
    MessageModel lastMessage,
    DateTime time,
  ) {
    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index == -1) return;

    final old = conversations[index];
    final updated = ConversationModel(
      id: old.id,
      patient: old.patient,
      lastMessage: lastMessage,
      unreadCount: old.unreadCount,
      createdAt: old.createdAt,
      updatedAt: time.toIso8601String(),
    );

    conversations.removeAt(index);
    conversations.insert(0, updated);
  }

  int? activeConversationId;

  void setActiveConversation(int? conversationId) {
    activeConversationId = conversationId;
  }

  void receiveIncomingMessage(int conversationId, MessageModel incoming) {
    final isActive = activeConversationId == conversationId;

    if (isActive) {
      final alreadyExists = messages.any((m) => m.id == incoming.id);
      if (!alreadyExists) {
        messages.insert(0, incoming);
      }
    }

    _syncConversationPreview(conversationId, incoming, DateTime.now());

    if (!isActive) {
      _incrementUnreadCount(conversationId);
    }

    notifyListeners();
  }

  void _incrementUnreadCount(int conversationId) {
    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index == -1) return;
    final old = conversations[index];
    conversations[index] = ConversationModel(
      id: old.id,
      patient: old.patient,
      lastMessage: old.lastMessage,
      unreadCount: old.unreadCount + 1,
      createdAt: old.createdAt,
      updatedAt: old.updatedAt,
    );
  }
}
