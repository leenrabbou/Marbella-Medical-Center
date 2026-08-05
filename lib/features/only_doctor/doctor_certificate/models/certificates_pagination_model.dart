import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/doctor_certificate/models/certificate_model.dart';

class CertificatesPaginationModel {
  final int currentPage;
  final List<CertificateModel> data;
  final int lastPage;

  CertificatesPaginationModel({
    required this.currentPage,
    required this.data,
    required this.lastPage,
  });

  factory CertificatesPaginationModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> patientsListJson = json[ApiKey.data];
    return CertificatesPaginationModel(
      currentPage: json[ApiKey.currentPage],
      lastPage: json[ApiKey.lastPage],
      data: patientsListJson
          .map(
            (item) => CertificateModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
