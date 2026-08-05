import 'package:marbella/core/databases/api/end_points.dart';

class CodeModel {
  final int id;
  final String system;
  final String code;
  final String display;
  final String category;
  final bool active;

  CodeModel({
    required this.id,
    required this.system,
    required this.code,
    required this.display,
    required this.category,
    required this.active,
  });

  factory CodeModel.fromJson(Map<String, dynamic> json) {
    return CodeModel(
      id: json[ApiKey.id],
      system: json[ApiKey.system],
      code: json[ApiKey.code],
      display: json[ApiKey.display],
      category: json[ApiKey.category],
      active: json[ApiKey.active],
    );
  }
}
