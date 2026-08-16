import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/chat/Models/message_model.dart';

class MessagesPaginationModel {
  final int currentPage;
  final List<MessageModel> data;
  final int lastPage;

  MessagesPaginationModel({
    required this.currentPage,
    required this.data,
    required this.lastPage,
  });

  factory MessagesPaginationModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> listJson = json[ApiKey.data];
    return MessagesPaginationModel(
      currentPage: json[ApiKey.currentPage],
      lastPage: json[ApiKey.lastPage],
      data: listJson
          .map((item) => MessageModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
