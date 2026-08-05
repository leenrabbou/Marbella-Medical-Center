import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/patients/models/image_model.dart';

class PatientModel {
  final int id;
  final ImageModel? image;
  final String givenName;
  final String familyName;
  final String gender;
  final String phoneNumber;
  final String? phoneNumberVerifiedAt;
  final String dateOfBirth;
  final String nationalId;
  final String socialHistory;
  final String occupation;
  final String maritalStatus;
  final String bloodGroup;
  final bool active;
  final String? notes;
  PatientModel({
    required this.id,
    required this.image,
    required this.phoneNumber,
    required this.givenName,
    required this.familyName,
    required this.gender,
    required this.phoneNumberVerifiedAt,
    required this.maritalStatus,
    required this.dateOfBirth,
    required this.socialHistory,
    required this.occupation,
    required this.active,
    required this.nationalId,
    required this.notes,
    required this.bloodGroup,
  });
  factory PatientModel.fromJson(Map<String, dynamic> jsonData) {
    return PatientModel(
      id: jsonData[ApiKey.id] ?? 0,
      image: jsonData[ApiKey.image] != null
          ? ImageModel.fromJson(jsonData[ApiKey.image])
          : null,
      phoneNumber: jsonData[ApiKey.phoneNumber] ?? "",
      givenName: jsonData[ApiKey.givenName] ?? "",
      familyName: jsonData[ApiKey.familyName] ?? "",
      gender: jsonData[ApiKey.gender] ?? "",
      phoneNumberVerifiedAt: jsonData[ApiKey.phoneNumberVerifiedAt],
      maritalStatus: jsonData[ApiKey.maritalStatus] ?? "",
      dateOfBirth: jsonData[ApiKey.dateOfBirth] ?? "",
      socialHistory: jsonData[ApiKey.socialHistory] ?? "",
      occupation: jsonData[ApiKey.occupation] ?? "",
      active: jsonData[ApiKey.active] ?? false,
      nationalId: jsonData[ApiKey.nationalId] ?? "",
      notes: jsonData[ApiKey.notes],
      bloodGroup: jsonData[ApiKey.bloodGroup] ?? "",
    );
  }
}
