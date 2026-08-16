import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/chat/Models/conversation_model.dart';

class ConversationPaginationModel {
  final int currentPage;
  final List<ConversationModel> data;
  final int lastPage;

  ConversationPaginationModel({
    required this.currentPage,
    required this.data,
    required this.lastPage,
  });

  factory ConversationPaginationModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> listJson = json[ApiKey.data];
    return ConversationPaginationModel(
      currentPage: json[ApiKey.currentPage],
      lastPage: json[ApiKey.lastPage],
      data: listJson
          .map(
            (item) => ConversationModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
