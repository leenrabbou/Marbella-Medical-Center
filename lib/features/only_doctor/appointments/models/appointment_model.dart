import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/only_doctor/appointments/models/clinic_model.dart';
import 'package:marbella/features/only_doctor/appointments/models/service_model.dart';
import 'package:marbella/features/only_doctor/patients/models/patient_model.dart';

class AppointmentModel {
  final int id;
  final PatientModel patient;
  final ServiceModel service;
  final ClinicModel clinic;
  final String status;
  final String reason;
  final String startTime;
  final String endTime;
  final String? notes;
  final int price;

  AppointmentModel({
    required this.id,
    required this.patient,
    required this.service,
    required this.clinic,
    required this.reason,
    required this.status,
    required this.price,
    required this.startTime,
    required this.endTime,
    required this.notes,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> jsonData) {
    return AppointmentModel(
      id: jsonData[ApiKey.id],
      patient: PatientModel.fromJson(jsonData[ApiKey.patient]),
      service: ServiceModel.fromJson(jsonData[ApiKey.service]),
      clinic: ClinicModel.fromJson(jsonData[ApiKey.clinic]),
      reason: jsonData[ApiKey.reason],
      status: jsonData[ApiKey.status],
      price: jsonData[ApiKey.price],
      startTime: jsonData[ApiKey.startTime],
      endTime: jsonData[ApiKey.endTime],
      notes: jsonData[ApiKey.notes],
    );
  }
}
