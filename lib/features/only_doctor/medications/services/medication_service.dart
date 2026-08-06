import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/medications/models/medication_response_model.dart';
import 'package:marbella/features/only_doctor/medications/models/medications_list_model.dart';
import 'package:marbella/generated/l10n.dart';

class MedicationService {
  ApiServices apiService;
  MedicationService({required this.apiService});

  Future<Either<ErrorModel, MedicationsListModel>> getMedications(
    String locale,
    String? token,
  ) async {
    try {
      String url = EndPoints.medication;
      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );

      if (response[ApiKey.status] == 1) {
        final data = MedicationsListModel.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, MedicationResponseModel>> getMedicationDetails(
    String locale,
    String? token,
    int medicationId,
  ) async {
    try {
      String url = '${EndPoints.medication}/$medicationId';
      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );

      if (response[ApiKey.status] == 1) {
        final data = MedicationResponseModel.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> updateMedication(
    String locale,
    String token,
    UpdateMedicationParams params,
    int medicationId,
  ) async {
    try {
      FormData formData = FormData();

      formData.fields.addAll([
        if (params.system != null && params.system!.isNotEmpty)
          MapEntry(ApiKey.system, params.system!),
        if (params.code != null && params.code!.isNotEmpty)
          MapEntry(ApiKey.code, params.code!),
        if (params.display != null && params.display!.isNotEmpty)
          MapEntry(ApiKey.display, params.display!),
        if (params.description != null && params.description!.isNotEmpty)
          MapEntry(ApiKey.description, params.description!),
        if (params.form != null && params.form!.isNotEmpty)
          MapEntry(ApiKey.form, params.form!),
        if (params.strength != null && params.strength!.isNotEmpty)
          MapEntry(ApiKey.strength, params.strength!),
        MapEntry('_method', 'patch'),
      ]);

      if (params.image != null) {
        formData.files.add(
          MapEntry(ApiKey.image, await MultipartFile.fromFile(params.image!)),
        );
      }

      final response = await apiService.post(
        '${EndPoints.medication}/$medicationId',
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        data: formData,
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

  Future<Either<ErrorModel, void>> addMedication(
    String locale,
    String token,
    UpdateMedicationParams params,
  ) async {
    try {
      FormData formData = FormData();

      formData.fields.addAll([
        if (params.system != null) MapEntry(ApiKey.system, params.system!),
        if (params.code != null) MapEntry(ApiKey.code, params.code!),
        if (params.display != null) MapEntry(ApiKey.display, params.display!),
        if (params.description != null)
          MapEntry(ApiKey.description, params.description!),
        if (params.form != null) MapEntry(ApiKey.form, params.form!),
        if (params.strength != null)
          MapEntry(ApiKey.strength, params.strength!),
      ]);

      if (params.image != null) {
        formData.files.add(
          MapEntry(ApiKey.image, await MultipartFile.fromFile(params.image!)),
        );
      }

      final response = await apiService.post(
        EndPoints.medication,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        data: formData,
      );

      if (response.statusCode == 201) {
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

  Future<Either<ErrorModel, void>> deleteMedication(
    String locale,
    String token,
    int medicationId,
  ) async {
    try {
      final response = await apiService.delete(
        '${EndPoints.medication}/$medicationId',
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
