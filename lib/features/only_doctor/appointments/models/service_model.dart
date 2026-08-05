import 'package:marbella/core/databases/api/end_points.dart';

class ServiceModel {
  final int id;
  final String name;
  final String description;
  final int price;
  final int clinicId;
  final bool patientCanBook;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.clinicId,
    required this.patientCanBook,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> jsonData) {
    return ServiceModel(
      id: jsonData[ApiKey.id],
      name: jsonData[ApiKey.name],
      description: jsonData[ApiKey.description],
      price: jsonData[ApiKey.price],
      clinicId: jsonData[ApiKey.clinicId],
      patientCanBook: jsonData[ApiKey.patientCanBook],
    );
  }
}
