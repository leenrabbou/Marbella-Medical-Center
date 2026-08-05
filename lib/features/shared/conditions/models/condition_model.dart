import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/codes/models/code_model.dart';

class ConditionModel {
  final int id;
  final int patientId;
  final CodeModel code;
  final int? encounterId;
  final String clinicalStatus;
  final String verificationStatus;
  final String onsetDate;
  final String? abatementDate;
  final String? note;

  ConditionModel({
    required this.id,
    required this.patientId,
    required this.code,
    required this.encounterId,
    required this.clinicalStatus,
    required this.verificationStatus,
    required this.onsetDate,
    required this.abatementDate,
    required this.note,
  });

  factory ConditionModel.fromJson(Map<String, dynamic> json) {
    return ConditionModel(
      id: json[ApiKey.id],
      patientId: json[ApiKey.patientId],
      encounterId: json[ApiKey.encounterId],
      clinicalStatus: json[ApiKey.clinicalStatus],
      verificationStatus: json[ApiKey.verificationStatus],
      onsetDate: json[ApiKey.onsetDate],
      abatementDate: json[ApiKey.abatementDate],
      note: json[ApiKey.note],
      code: CodeModel.fromJson(json[ApiKey.code]),
    );
  }
}
