import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/patients/models/image_model.dart';

class ClinicModel {
  final int id;
  final ImageModel? image;
  final String name;
  final String description;

  ClinicModel({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
  });
  factory ClinicModel.fromJson(Map<String, dynamic> jsonData) {
    return ClinicModel(
      id: jsonData[ApiKey.id],
      image: jsonData[ApiKey.image] != null
          ? ImageModel.fromJson(jsonData[ApiKey.image])
          : null,
      name: jsonData[ApiKey.name],
      description: jsonData[ApiKey.description],
    );
  }
}
