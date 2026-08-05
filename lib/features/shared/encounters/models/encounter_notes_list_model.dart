import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/encounters/models/encounter_note_model.dart';

class EncounterNotesListModel {
  final int status;
  final List<EncounterNoteModel> data;
  final String message;

  EncounterNotesListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory EncounterNotesListModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> patientsListJson = json[ApiKey.data];
    return EncounterNotesListModel(
      status: json[ApiKey.status],
      message: json[ApiKey.message],
      data: patientsListJson
          .map(
            (item) => EncounterNoteModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
