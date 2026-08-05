import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/codes/models/code_model.dart';

class MedicalTestModel {
  final int id;
  final CodeModel code;
  final String name;
  final String category;
  final int price;
  final bool active;

  MedicalTestModel({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.price,
    required this.active,
  });

  factory MedicalTestModel.fromJson(Map<String, dynamic> jsonData) {
    return MedicalTestModel(
      id: jsonData[ApiKey.id],
      code: CodeModel.fromJson(jsonData[ApiKey.code]),
      name: jsonData[ApiKey.name],
      category: jsonData[ApiKey.category],
      price: jsonData[ApiKey.price],
      active: jsonData[ApiKey.active],
    );
  }
}
