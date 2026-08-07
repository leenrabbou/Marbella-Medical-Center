import 'package:dartz/dartz.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/conflict_error.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/medications/models/medication_conflict_model.dart';
import 'package:marbella/features/shared/patient_medications/models/patient_medications_list.dart';
import 'package:marbella/features/shared/patient_medications/models/patient_medications_response.dart';
import 'package:marbella/generated/l10n.dart';

class PatientMedicationsService {
  ApiServices apiService;
  PatientMedicationsService({required this.apiService});
  Future<Either<ErrorModel, PatientMedicationsList>> getPatientMedications(
    String locale,
    String? token,
    PatientMedicationsParams params,
  ) async {
    try {
      String url = EndPoints.patientMedication;
      Map<String, dynamic> queryParameters = {
        if (params.encounterId != null)
          'filter[encounter_id]': params.encounterId!.toString(),
        if (params.patientId != null)
          'filter[patient_id]': params.patientId!.toString(),
        if (params.doctorId != null)
          'filter[doctor_id]': params.doctorId!.toString(),
        if (params.status != null && params.status!.isNotEmpty)
          'filter[status]': params.status!,
      };
      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        queryParameters: queryParameters,
      );
      if (response[ApiKey.status] == 1) {
        final data = PatientMedicationsList.fromJson(response);
        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, PatientMedicationsResponse>>
  getPatientMedicationDetails(String locale, String? token, int id) async {
    try {
      final response = await apiService.get(
        "${EndPoints.patientMedication}/$id",
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );

      if (response[ApiKey.status] == 1) {
        final data = PatientMedicationsResponse.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> updatePatientMedication(
    String locale,
    String token,
    UpdatePatientMedicationParams params,
    int patientMedicationId,
  ) async {
    try {
      Map<String, String> data = {'_method': 'patch'};
      if (params.medicationId != null) {
        data.addAll({ApiKey.medicationId: params.medicationId.toString()});
      }
      if (params.dosage != null && params.dosage!.isNotEmpty) {
        data.addAll({ApiKey.dosage: params.dosage!});
      }
      if (params.route != null && params.route!.isNotEmpty) {
        data.addAll({ApiKey.route: params.route!});
      }
      if (params.durationValue != null) {
        data.addAll({ApiKey.durationValue: params.durationValue.toString()});
      }
      if (params.durationUnit != null && params.durationUnit!.isNotEmpty) {
        data.addAll({ApiKey.durationUnit: params.durationUnit!});
      }
      if (params.notes != null && params.notes!.isNotEmpty) {
        data.addAll({ApiKey.notes: params.notes!});
      }
      final response = await apiService.post(
        '${EndPoints.patientMedication}/$patientMedicationId',
        headers: {"locale": locale, "Authorization": 'Bearer $token'},

        data: data,
      );
      if (response.statusCode == 200) {
        return Right(null);
      }
      final error = ErrorModel(
        status: response.statusCode,
        errorMessage: response.error?.errorMessage ?? S().unknown_error,
      );
      return Left(error);
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> addPatientMedication(
    String locale,
    String token,
    AddPatientMedicationParams params,
  ) async {
    try {
      final response = await apiService.post(
        EndPoints.patientMedication,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        data: {
          ApiKey.encounterId: params.encounterId,
          ApiKey.medicationId: params.medicationId,
          ApiKey.dosage: params.dosage,
          ApiKey.route: params.route,
          ApiKey.durationValue: params.durationValue,
          ApiKey.durationUnit: params.durationUnit,
          ApiKey.notes: params.notes,
          ApiKey.override: params.override,
        },
      );

      if (response.statusCode == 201) {
        return Right(null);
      }

      if (response.statusCode == 409) {
        final rawData = response.error?.rawData;
        if (rawData == null) {
          return Left(
            ErrorModel(
              status: 409,
              errorMessage: response.error?.errorMessage ?? S().unknown_error,
            ),
          );
        }

        final conflict = MedicationConflictModel.fromJson(
          Map<String, dynamic>.from(rawData),
        );

        return Left(
          ConflictError(
            status: 409,
            errorMessage: conflict.message,
            interactions: conflict.interactions,
          ),
        );
      }

      final error = ErrorModel(
        status: response.statusCode,
        errorMessage: response.error?.errorMessage ?? S().unknown_error,
      );
      return Left(error);
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> deletePatientMedication(
    String locale,
    String token,
    int patientMedicationId,
  ) async {
    try {
      final response = await apiService.delete(
        '${EndPoints.patientMedication}/$patientMedicationId',
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return Right(null);
      }
      final error = ErrorModel(
        status: response.statusCode,
        errorMessage: response.error?.errorMessage ?? S().unknown_error,
      );
      return Left(error);
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }
}
