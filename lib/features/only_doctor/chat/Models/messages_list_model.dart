import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/chat/Models/messages_pagination_model.dart';

class MessagesListModel {
  final int status;
  final MessagesPaginationModel data;
  final String message;

  MessagesListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory MessagesListModel.fromJson(Map<String, dynamic> jsonData) {
    return MessagesListModel(
      status: jsonData[ApiKey.status],
      message: jsonData[ApiKey.message],
      data: MessagesPaginationModel.fromJson(jsonData[ApiKey.data]),
    );
  }
}
