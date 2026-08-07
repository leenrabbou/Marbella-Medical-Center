import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/audit/models/audit_model.dart';

class AuditListModel {
  final int status;
  final List<AuditModel> data;
  final String message;

  AuditListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory AuditListModel.fromJson(Map<String, dynamic> jsonData) {
    return AuditListModel(
      status: jsonData[ApiKey.status],
      message: jsonData[ApiKey.message],
      data: List.from(
        jsonData[ApiKey.data],
      ).map((val) => AuditModel.fromJson(val)).toList(),
    );
  }
}
