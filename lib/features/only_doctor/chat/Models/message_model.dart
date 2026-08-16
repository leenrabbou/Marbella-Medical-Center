import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/patients/models/image_model.dart';

enum MessageLocalStatus { sending, sent, failed }

class MessageModel {
  final int id;
  final String type;
  final String body;
  final int isSeen;
  final int isSender;
  final String sentAt;
  final String? readAt;
  final List<ImageModel> attachments;
  final MessageLocalStatus localStatus;

  MessageModel({
    required this.id,
    required this.type,
    required this.body,
    required this.isSeen,
    required this.isSender,
    required this.sentAt,
    required this.readAt,
    required this.attachments,
    this.localStatus = MessageLocalStatus.sent,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json[ApiKey.id],
      type: json[ApiKey.type],
      body: json[ApiKey.body],
      isSeen: json[ApiKey.isSeen],
      isSender: json[ApiKey.isSender],
      sentAt: json[ApiKey.sentAt],
      readAt: json[ApiKey.readAt],
      attachments: json[ApiKey.attachments] == null
          ? []
          : (json[ApiKey.attachments] as List)
                .map(
                  (item) => ImageModel.fromJson(item as Map<String, dynamic>),
                )
                .toList(),
    );
  }

  MessageModel copyWith({
    int? id,
    int? isSeen,
    MessageLocalStatus? localStatus,
    List<ImageModel>? attachments,
  }) {
    return MessageModel(
      id: id ?? this.id,
      type: type,
      body: body,
      isSeen: isSeen ?? this.isSeen,
      isSender: isSender,
      sentAt: sentAt,
      readAt: readAt,
      attachments: attachments ?? this.attachments,
      localStatus: localStatus ?? this.localStatus,
    );
  }
}
