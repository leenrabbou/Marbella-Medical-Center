import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/codes/models/code_model.dart';
import 'package:marbella/features/only_doctor/patients/models/image_model.dart';

class MedicationModel {
  final int id;
  final ImageModel? image;
  final CodeModel code;
  final String? description;
  final String form;
  final String? strength;

  MedicationModel({
    required this.id,
    required this.image,
    required this.code,
    required this.description,
    required this.form,
    required this.strength,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json[ApiKey.id],
      description: json[ApiKey.description],
      form: json[ApiKey.form],
      strength: json[ApiKey.strength],
      code: CodeModel.fromJson(json[ApiKey.code]),
      image: json[ApiKey.image] != null
          ? ImageModel.fromJson(json[ApiKey.image])
          : null,
    );
  }
}
