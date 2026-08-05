import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/auth/models/user_model.dart';

class AuthResponseModel {
  final int status;
  final UserModel? data;
  final String message;

  AuthResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      status: json[ApiKey.status] ?? 0,
      message: json[ApiKey.message] ?? '',
      data: json[ApiKey.data] == null
          ? null
          : UserModel.fromJson(json[ApiKey.data]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.status: status,
      ApiKey.message: message,
      ApiKey.data: data?.toJson(),
    };
  }
}
