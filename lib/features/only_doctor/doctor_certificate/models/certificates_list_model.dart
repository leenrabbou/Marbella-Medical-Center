import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/doctor_certificate/models/certificates_pagination_model.dart';

class CertificatesListModel {
  final int status;
  final CertificatesPaginationModel data;
  final String message;

  CertificatesListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CertificatesListModel.fromJson(Map<String, dynamic> jsonData) {
    return CertificatesListModel(
      status: jsonData[ApiKey.status],
      message: jsonData[ApiKey.message],
      data: CertificatesPaginationModel.fromJson(jsonData[ApiKey.data]),
    );
  }
}
