import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/chat/Models/message_model.dart';
import 'package:marbella/features/only_doctor/patients/models/patient_model.dart';

class ConversationModel {
  final int id;
  final PatientModel patient;
  final MessageModel? lastMessage;
  final int unreadCount;
  final String createdAt;
  final String updatedAt;

  ConversationModel({
    required this.id,
    required this.patient,
    required this.lastMessage,
    required this.unreadCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json[ApiKey.id],
      patient: PatientModel.fromJson(json[ApiKey.patient]),
      lastMessage: json[ApiKey.lastMessage] != null
          ? MessageModel.fromJson(json[ApiKey.lastMessage])
          : null,
      unreadCount: json[ApiKey.unreadCount],
      createdAt: json[ApiKey.createdAt],
      updatedAt: json[ApiKey.updatedAt],
    );
  }

  ConversationModel copyWith({
    int? id,
    PatientModel? patient,
    MessageModel? lastMessage,
    int? unreadCount,
    String? createdAt,
    String? updatedAt,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      patient: patient ?? this.patient,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
