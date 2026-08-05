import 'package:marbella/core/databases/api/end_points.dart';

class LabResultModel {
  final int id;
  final String name;
  final String code;
  final num? referenceRangeMin;
  final num? referenceRangeMax;
  final String? value;
  final String? unit;
  final String datatype;
  final String? flag;
  final String? notes;

  LabResultModel({
    required this.id,
    required this.name,
    required this.code,
    required this.referenceRangeMin,
    required this.referenceRangeMax,
    required this.value,
    required this.unit,
    required this.datatype,
    required this.flag,
    required this.notes,
  });

  factory LabResultModel.fromJson(Map<String, dynamic> jsonData) {
    return LabResultModel(
      id: jsonData[ApiKey.id],
      name: jsonData[ApiKey.name],
      code: jsonData[ApiKey.code],
      referenceRangeMin: jsonData[ApiKey.referenceRangeMin],
      referenceRangeMax: jsonData[ApiKey.referenceRangeMax],
      value: jsonData[ApiKey.value]?.toString(),
      unit: jsonData[ApiKey.unit],
      datatype: jsonData[ApiKey.datatype],
      flag: jsonData[ApiKey.flag],
      notes: jsonData[ApiKey.notes],
    );
  }
}
