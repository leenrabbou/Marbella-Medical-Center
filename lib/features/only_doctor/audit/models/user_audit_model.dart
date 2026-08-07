import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/patients/models/image_model.dart';

class UserAuditModel {
  final int id;
  final ImageModel? image;
  final String name;
  final String phoneNumber;
  final String role;

  UserAuditModel({
    required this.id,
    required this.image,
    required this.name,
    required this.phoneNumber,
    required this.role,
  });

  factory UserAuditModel.fromJson(Map<String, dynamic> jsonData) {
    return UserAuditModel(
      id: jsonData[ApiKey.id],
      image: jsonData[ApiKey.image] != null
          ? ImageModel.fromJson(jsonData[ApiKey.image])
          : null,
      name: jsonData[ApiKey.name],
      phoneNumber: jsonData[ApiKey.phoneNumber],
      role: jsonData[ApiKey.role],
    );
  }
}
