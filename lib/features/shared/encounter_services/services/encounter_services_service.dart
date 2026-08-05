import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/encounter_services/models/encounter_services_list_model.dart';
import 'package:marbella/features/shared/encounter_services/models/services_list_model.dart';
import 'package:marbella/generated/l10n.dart';

class EncounterServicesService {
  ApiServices apiService;
  EncounterServicesService({required this.apiService});

  Future<Either<ErrorModel, EncounterServicesListModel>> getEncounterServices(
    String locale,
    String? token,
    EncounterServiceParams params,
  ) async {
    try {
      String url = EndPoints.encounterService;
      Map<String, dynamic> queryParameters = {
        'filter[encounter_id]': params.encounterId.toString(),

        if (params.status != null && params.status!.isNotEmpty)
          'filter[status]': params.status!,
      };
      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        queryParameters: queryParameters,
      );

      if (response[ApiKey.status] == 1) {
        final data = EncounterServicesListModel.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> updateEncounterService(
    String locale,
    String token,
    UpdateEncounterServiceParams params,
    int encounterServiceId,
  ) async {
    try {
      FormData formData = FormData();

      formData.fields.addAll([
        if (params.status != null && params.status!.isNotEmpty)
          MapEntry(ApiKey.status, params.status!),
        if (params.note != null && params.note!.isNotEmpty)
          MapEntry(ApiKey.notes, params.note!),
        MapEntry('_method', 'patch'),
      ]);

      final response = await apiService.post(
        '${EndPoints.encounterService}/$encounterServiceId',
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

  Future<Either<ErrorModel, void>> addEncounterService(
    String locale,
    String token,
    AddEncounterServiceParams params,
  ) async {
    try {
      FormData formData = FormData();

      formData.fields.addAll([
        if (params.encounterId != null)
          MapEntry(ApiKey.encounterId, params.encounterId.toString()),
        if (params.serviceId != null)
          MapEntry(ApiKey.serviceId, params.serviceId.toString()),
      ]);

      final response = await apiService.post(
        EndPoints.encounterService,
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

  Future<Either<ErrorModel, void>> deleteEncounterService(
    String locale,
    String token,
    int encounterServiceId,
  ) async {
    try {
      final response = await apiService.delete(
        '${EndPoints.encounterService}/$encounterServiceId',
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

  Future<Either<ErrorModel, ServicesListModel>> getAllServicesList(
    String locale,
    String? token,
  ) async {
    try {
      String url = EndPoints.allServices;

      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );

      if (response[ApiKey.status] == 1) {
        final data = ServicesListModel.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }
}
