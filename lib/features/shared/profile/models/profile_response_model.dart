import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/profile/models/user_model.dart';

class ProfileResponseModel {
  final int status;
  final EmployeeModel? data;
  final String message;
  ProfileResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });
  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      status: json[ApiKey.status] ?? 0,
      message: json[ApiKey.message] ?? '',
      data: json[ApiKey.data] == null
          ? null
          : EmployeeModel.fromJson(json[ApiKey.data]),
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
