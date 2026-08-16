import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/chat/Models/conversation_pagination_model.dart';

class ConversationListModel {
  final int status;
  final ConversationPaginationModel data;
  final String message;

  ConversationListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ConversationListModel.fromJson(Map<String, dynamic> jsonData) {
    return ConversationListModel(
      status: jsonData[ApiKey.status],
      message: jsonData[ApiKey.message],
      data: ConversationPaginationModel.fromJson(jsonData[ApiKey.data]),
    );
  }
}
