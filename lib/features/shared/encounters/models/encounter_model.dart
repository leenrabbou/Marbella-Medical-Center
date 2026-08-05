import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/patients/models/patient_model.dart';
import 'package:marbella/features/shared/encounters/models/only_nurse/doctor_model.dart';

class EncounterModel {
  final int id;
  final PatientModel patient;
  final DoctorModel? doctor;
  final String status;
  final String? startTime;
  final String? endTime;
  final String? reason;
  final String? notes;

  EncounterModel({
    required this.id,
    required this.patient,
    required this.doctor,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.notes,
    required this.reason,
  });

  factory EncounterModel.fromJson(Map<String, dynamic> jsonData) {
    return EncounterModel(
      id: jsonData[ApiKey.id],
      doctor: jsonData[ApiKey.doctor] != null
          ? DoctorModel.fromJson(jsonData[ApiKey.doctor])
          : null,
      patient: PatientModel.fromJson(jsonData[ApiKey.patient]),
      reason: jsonData[ApiKey.reason],
      status: jsonData[ApiKey.status],
      startTime: jsonData[ApiKey.startTime],
      endTime: jsonData[ApiKey.endTime],
      notes: jsonData[ApiKey.notes],
    );
  }

  EncounterModel copyWith({String? reason, String? notes, String? status}) {
    return EncounterModel(
      id: id,
      patient: patient,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      startTime: startTime,
      endTime: endTime,
      doctor: doctor,
    );
  }
}
