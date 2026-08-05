import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/lab_tests/models/lab_result_model.dart';
import 'package:marbella/features/only_doctor/patients/models/patient_model.dart';

class LabTestModel {
  final int id;
  final PatientModel patient;
  final String name;
  final String category;
  final String codeSystem;
  final String code;
  final String status;
  final int price;
  final String orderedAt;
  final String? sampleCollectedAt;
  final String? completedAt;
  final String? notes;
  final List<LabResultModel>? results;

  LabTestModel({
    required this.id,
    required this.patient,
    required this.name,
    required this.category,
    required this.code,
    required this.codeSystem,
    required this.completedAt,
    required this.notes,
    required this.orderedAt,
    required this.price,
    required this.sampleCollectedAt,
    required this.status,
    this.results,
  });

  factory LabTestModel.fromJson(Map<String, dynamic> jsonData) {
    return LabTestModel(
      id: jsonData[ApiKey.id],
      patient: PatientModel.fromJson(jsonData[ApiKey.patient]),
      status: jsonData[ApiKey.status],
      price: jsonData[ApiKey.price],
      notes: jsonData[ApiKey.notes],
      name: jsonData[ApiKey.name],
      category: jsonData[ApiKey.category],
      code: jsonData[ApiKey.code],
      codeSystem: jsonData[ApiKey.codeSystem],
      completedAt: jsonData[ApiKey.completedAt],
      orderedAt: jsonData[ApiKey.orderedAt],
      sampleCollectedAt: jsonData[ApiKey.sampleCollectedAt],
      results: jsonData[ApiKey.results] != null
          ? (jsonData[ApiKey.results] as List)
                .map((e) => LabResultModel.fromJson(e))
                .toList()
          : null,
    );
  }
}
