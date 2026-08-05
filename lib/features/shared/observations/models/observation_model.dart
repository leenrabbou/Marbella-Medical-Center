import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/codes/models/code_model.dart';

class ObservationModel {
  final int id;
  final int patientId;
  final int? encounterId;
  final String status;
  final String effectiveDatetime;
  final String? issuedAt;
  final String? value;
  final String? unit;
  final String? note;
  final CodeModel code;

  ObservationModel({
    required this.id,
    required this.patientId,
    this.encounterId,
    required this.status,
    required this.effectiveDatetime,
    required this.issuedAt,
    required this.value,
    this.unit,
    this.note,
    required this.code,
  });
  factory ObservationModel.fromJson(Map<String, dynamic> json) {
    return ObservationModel(
      id: json[ApiKey.id],
      patientId: json[ApiKey.patientId],
      encounterId: json[ApiKey.encounterId],
      status: json[ApiKey.status],
      effectiveDatetime: json[ApiKey.effectiveDatetime],
      value: json[ApiKey.value],
      unit: json[ApiKey.unit],
      note: json[ApiKey.note],
      code: CodeModel.fromJson(json[ApiKey.code]),
      issuedAt: json[ApiKey.issuedAt],
    );
  }
}
