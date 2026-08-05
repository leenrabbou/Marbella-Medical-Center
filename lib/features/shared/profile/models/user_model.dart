import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/patients/models/image_model.dart';

class EmployeeModel {
  int id;
  ImageModel? image;
  String firstName;
  String lastName;
  String phoneNumber;
  String? phoneNumberVerifiedAt;
  String birthDate;
  int age;
  String gender;
  String ssn;
  String? address;
  String? socialHistory;
  String? maritalStatus;
  String role;
  String specialization;
  String? experiences;
  EmployeeModel({
    required this.id,
    required this.image,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.phoneNumberVerifiedAt,
    required this.birthDate,
    required this.age,
    required this.gender,
    required this.ssn,
    required this.address,
    required this.role,
    required this.socialHistory,
    required this.maritalStatus,
    required this.specialization,
    required this.experiences,
  });
  factory EmployeeModel.fromJson(Map<String, dynamic> jsonData) {
    return EmployeeModel(
      id: jsonData[ApiKey.id],
      image: jsonData[ApiKey.image] != null
          ? ImageModel.fromJson(jsonData[ApiKey.image])
          : null,
      firstName: jsonData[ApiKey.firstName],
      lastName: jsonData[ApiKey.lastName],
      phoneNumber: jsonData[ApiKey.phoneNumber],
      birthDate: jsonData[ApiKey.birthDate],
      age: jsonData[ApiKey.age],
      gender: jsonData[ApiKey.gender],
      ssn: jsonData[ApiKey.ssn],
      address: jsonData[ApiKey.address],
      role: jsonData[ApiKey.role],
      socialHistory: jsonData[ApiKey.socialHistory],
      maritalStatus: jsonData[ApiKey.maritalStatus],
      specialization: jsonData[ApiKey.specialization],
      experiences: jsonData[ApiKey.experiences],
      phoneNumberVerifiedAt: jsonData[ApiKey.phoneNumberVerifiedAt],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      ApiKey.id: id,
      ApiKey.image: image,
      ApiKey.firstName: firstName,
      ApiKey.lastName: lastName,
      ApiKey.phoneNumber: phoneNumber,
      ApiKey.phoneNumberVerifiedAt: phoneNumberVerifiedAt,
      ApiKey.birthDate: birthDate,
      ApiKey.age: age,
      ApiKey.gender: gender,
      ApiKey.ssn: ssn,
      ApiKey.address: address,
      ApiKey.role: role,
      ApiKey.socialHistory: socialHistory,
      ApiKey.maritalStatus: maritalStatus,
      ApiKey.specialization: specialization,
      ApiKey.experiences: experiences,
    };
  }
}
