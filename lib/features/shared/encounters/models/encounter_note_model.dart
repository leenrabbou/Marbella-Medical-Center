import 'package:marbella/core/databases/api/end_points.dart';

class EncounterNoteModel {
  final int id;
  final int patientId;
  final int encounterId;
  final String title;
  final String note;
  final int? durationValue;
  final String? durationUnit;
  final String? untilDate;
  EncounterNoteModel({
    required this.id,
    required this.patientId,
    required this.encounterId,
    required this.title,
    required this.note,
    required this.durationUnit,
    required this.durationValue,
    required this.untilDate,
  });

  factory EncounterNoteModel.fromJson(Map<String, dynamic> jsonData) {
    return EncounterNoteModel(
      id: jsonData[ApiKey.id],
      patientId: jsonData[ApiKey.patientId],
      encounterId: jsonData[ApiKey.encounterId],
      title: jsonData[ApiKey.title],
      note: jsonData[ApiKey.note],
      durationUnit: jsonData[ApiKey.durationUnit],
      durationValue: jsonData[ApiKey.durationValue],
      untilDate: jsonData[ApiKey.untilDate],
    );
  }
}
