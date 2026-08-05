import 'package:marbella/core/databases/api/end_points.dart';

class ImageModel {
  final int id;
  final String originalName;
  final String mimeType;
  final int size;
  final String url;
  ImageModel({
    required this.id,
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.url,
  });
  factory ImageModel.fromJson(Map<String, dynamic> jsonData) {
    return ImageModel(
      id: jsonData[ApiKey.id],
      originalName: jsonData[ApiKey.originalName],
      mimeType: jsonData[ApiKey.mimeType],
      size: jsonData[ApiKey.size],
      url: jsonData[ApiKey.url],
    );
  }
}
