import 'package:marbella/core/databases/api/end_points.dart';

class CertificateFileModel {
  final int id;
  final String originalName;
  final String mimeType;
  final int size;
  final String url;

  CertificateFileModel({
    required this.id,
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.url,
  });

  factory CertificateFileModel.fromJson(Map<String, dynamic> json) {
    return CertificateFileModel(
      id: json[ApiKey.id],
      originalName: json[ApiKey.originalName],
      mimeType: json[ApiKey.mimeType],
      size: json[ApiKey.size],
      url: json[ApiKey.url],
    );
  }
}
