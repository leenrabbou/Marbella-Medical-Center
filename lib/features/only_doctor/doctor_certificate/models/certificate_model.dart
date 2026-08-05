import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/doctor_certificate/models/certificate_file_model.dart';

class CertificateModel {
  final int id;
  final int doctorId;
  final String title;
  final String issuer;
  final String issuedAt;
  final CertificateFileModel? file;
  final String status;
  final String createdAt;

  CertificateModel({
    required this.id,
    required this.doctorId,
    required this.title,
    required this.issuer,
    required this.issuedAt,
    required this.file,
    required this.status,
    required this.createdAt,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json[ApiKey.id],
      doctorId: json[ApiKey.doctorId],
      title: json[ApiKey.title],
      issuer: json[ApiKey.issuer],
      issuedAt: json[ApiKey.issuedAt],
      file: json[ApiKey.file] != null
          ? CertificateFileModel.fromJson(json[ApiKey.file])
          : null,
      status: json[ApiKey.status],
      createdAt: json[ApiKey.createdAt],
    );
  }
}
