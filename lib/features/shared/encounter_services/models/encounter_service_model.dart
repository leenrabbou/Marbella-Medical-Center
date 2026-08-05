import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/appointments/models/service_model.dart';

class EncounterServiceModel {
  final int id;
  final int encounterId;
  final ServiceModel service;
  final int price;
  final String performedByType;
  final int performedById;
  final String? performedAt;
  final String status;
  final String? notes;

  EncounterServiceModel({
    required this.id,
    required this.encounterId,
    required this.service,
    required this.performedAt,
    required this.performedByType,
    required this.performedById,
    required this.notes,
    required this.price,
    required this.status,
  });

  factory EncounterServiceModel.fromJson(Map<String, dynamic> jsonData) {
    return EncounterServiceModel(
      id: jsonData[ApiKey.id],
      encounterId: jsonData[ApiKey.encounterId],
      service: ServiceModel.fromJson(jsonData[ApiKey.service]),
      performedAt: jsonData[ApiKey.performedAt],
      performedByType: jsonData[ApiKey.performedByType],
      performedById: jsonData[ApiKey.performedById],
      notes: jsonData[ApiKey.notes],
      price: jsonData[ApiKey.price],
      status: jsonData[ApiKey.status],
    );
  }
}
