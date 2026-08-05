import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/patients/models/image_model.dart';

class DoctorModel {
  final int id;
  final ImageModel? image;
  final String firstName;
  final String lastName;
  final int clinicId;
  final String clinicName;
  final String gender;
  final String specialization;
  final String brief;
  final int ratingAvg;
  final String phoneNumber;
  final String phoneNumberVerifiedAt;
  final int age;
  final String ssn;
  final String? address;
  final String socialHistory;
  final String maritalStatus;
  final String experiences;

  DoctorModel({
    required this.id,
    required this.image,
    required this.firstName,
    required this.lastName,
    required this.clinicId,
    required this.clinicName,
    required this.gender,
    required this.specialization,
    required this.brief,
    required this.ratingAvg,
    required this.phoneNumber,
    required this.phoneNumberVerifiedAt,
    required this.age,
    required this.ssn,
    required this.address,
    required this.socialHistory,
    required this.maritalStatus,
    required this.experiences,
  });
  factory DoctorModel.fromJson(Map<String, dynamic> jsonData) {
    return DoctorModel(
      id: jsonData[ApiKey.id],
      image: jsonData[ApiKey.image] != null
          ? ImageModel.fromJson(jsonData[ApiKey.image])
          : null,
      firstName: jsonData[ApiKey.firstName],
      lastName: jsonData[ApiKey.lastName],
      clinicId: jsonData[ApiKey.clinicId],
      clinicName: jsonData[ApiKey.clinicName],
      gender: jsonData[ApiKey.gender],
      specialization: jsonData[ApiKey.specialization],
      brief: jsonData[ApiKey.brief],
      ratingAvg: jsonData[ApiKey.ratingAvg],
      phoneNumber: jsonData[ApiKey.phoneNumber],
      phoneNumberVerifiedAt: jsonData[ApiKey.phoneNumberVerifiedAt],
      age: jsonData[ApiKey.age],
      ssn: jsonData[ApiKey.ssn],
      address: jsonData[ApiKey.address],
      socialHistory: jsonData[ApiKey.socialHistory],
      maritalStatus: jsonData[ApiKey.maritalStatus],
      experiences: jsonData[ApiKey.experiences],
    );
  }
}
