import 'package:dartz/dartz.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/observations/models/observation_list_model.dart';
import 'package:marbella/generated/l10n.dart';

class ObservationService {
  ApiServices apiService;
  ObservationService({required this.apiService});

  Future<Either<ErrorModel, ObservationListModel>> getObservations(
    String locale,
    String? token,
    ObservationParams params,
  ) async {
    try {
      String url = EndPoints.observation;
      Map<String, dynamic> queryParameters = {
        if (params.encounterId != null)
          'filter[encounter_id]': params.encounterId!.toString(),

        if (params.patientId != null)
          'filter[patient_id]': params.patientId!.toString(),
        if (params.codeId != null) 'filter[code_id]': params.codeId!.toString(),
        if (params.status != null) 'filter[status]': params.status!,
      };
      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        queryParameters: queryParameters,
      );

      if (response[ApiKey.status] == 1) {
        final data = ObservationListModel.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> updateObservation(
    String locale,
    String token,
    UpdateObservationParams params,
    int observationId,
  ) async {
    try {
      final response = await apiService.post(
        '${EndPoints.observation}/$observationId',
        headers: {"locale": locale, "Authorization": 'Bearer $token'},

        data: {
          ApiKey.codeId: params.codeId,
          ApiKey.status: params.status,
          ApiKey.effectiveDatetime: params.effectiveDatetime,
          ApiKey.issuedAt: params.issuedAt,
          ApiKey.value: params.value,
          ApiKey.unit: params.unit,
          ApiKey.note: params.note,
          '_method': 'patch',
        },
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

  Future<Either<ErrorModel, void>> addObservation(
    String locale,
    String token,
    AddObservationParams params,
  ) async {
    try {
      final response = await apiService.post(
        EndPoints.observation,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},

        data: {
          ApiKey.encounterId: params.encounterId,
          ApiKey.codeId: params.codeId,
          ApiKey.status: params.status,
          ApiKey.effectiveDatetime: params.effectiveDatetime,
          ApiKey.issuedAt: params.issuedAt,
          ApiKey.value: params.value,
          ApiKey.unit: params.unit,
          ApiKey.note: params.note,
        },
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

  Future<Either<ErrorModel, void>> deleteObservation(
    String locale,
    String token,
    int observationId,
  ) async {
    try {
      final response = await apiService.delete(
        '${EndPoints.observation}/$observationId',
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
