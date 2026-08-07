import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/audit/models/user_audit_model.dart';

class AuditModel {
  final int id;
  final UserAuditModel user;
  final String event;
  final Map<String, dynamic> oldValues;
  final Map<String, dynamic> newValues;
  final String updatedAt;

  AuditModel({
    required this.id,
    required this.user,
    required this.event,
    required this.oldValues,
    required this.newValues,
    required this.updatedAt,
  });

  factory AuditModel.fromJson(Map<String, dynamic> json) {
    return AuditModel(
      id: json[ApiKey.id],
      user: UserAuditModel.fromJson(json[ApiKey.user]),
      event: json[ApiKey.event],
      oldValues: _parseValues(json[ApiKey.oldValues]),
      newValues: _parseValues(json[ApiKey.newValues]),
      updatedAt: json[ApiKey.updatedAt],
    );
  }

  static Map<String, dynamic> _parseValues(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return {};
  }
}
