import 'package:marbella/core/databases/api/end_points.dart';

class UserModel {
  final int id;
  final String name;
  final String phoneNumber;
  final String? phoneNumberVerifiedAt;
  final String? token;
  final String? role;

  UserModel({
    required this.token,
    required this.name,
    required this.id,
    required this.phoneNumberVerifiedAt,
    required this.role,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[ApiKey.id],
      token: json[ApiKey.token],
      name: json[ApiKey.name],
      phoneNumberVerifiedAt: json[ApiKey.phoneNumberVerifiedAt],
      role: json[ApiKey.role] ?? "",
      phoneNumber: json[ApiKey.phoneNumber] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.id: id,
      ApiKey.token: token,
      ApiKey.name: name,
      ApiKey.phoneNumberVerifiedAt: phoneNumberVerifiedAt,
      ApiKey.role: role ?? "",
      ApiKey.phoneNumber: phoneNumber,
    };
  }

  UserModel copyWith({String? phoneNumberVerifiedAt}) {
    return UserModel(
      id: id,
      name: name,
      phoneNumberVerifiedAt:
          phoneNumberVerifiedAt ?? this.phoneNumberVerifiedAt,
      token: token,
      role: role ?? "",
      phoneNumber: phoneNumber,
    );
  }
}
