import 'package:dartz/dartz.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/encounters/models/encounter_response_model.dart';
import 'package:marbella/features/shared/encounters/models/encounters_list_model.dart';

class EncountersService {
  ApiServices apiService;
  EncountersService({required this.apiService});

  Future<Either<ErrorModel, EncountersListModel>> getEncounters(
    String locale,
    String? token,
    int page,
    EncounterParams params,
  ) async {
    try {
      String url = "${EndPoints.encounter}?page=$page";
      final queryParams = <String, String>{};
      if (params.status != null) queryParams['filter[status]'] = params.status!;
      if (params.patientId != null) {
        queryParams['filter[patient_id]'] = params.patientId.toString();
      }

      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      if (response[ApiKey.status] == 1) {
        final data = EncountersListModel.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, EncounterResponseModel>> getEncounterDetails(
    String locale,
    String? token,
    int id,
  ) async {
    try {
      final response = await apiService.get(
        "${EndPoints.encounter}/$id",
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );

      if (response[ApiKey.status] == 1) {
        final data = EncounterResponseModel.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> updateEncounters(
    String locale,
    String token,
    int encounterId,
    UpdateEncounterParams params,
  ) async {
    try {
      Map<String, String> data = {'_method': 'patch'};
      if (params.reason != null && params.reason!.isNotEmpty) {
        data.addAll({ApiKey.reason: params.reason!});
      }
      if (params.status != null && params.status!.isNotEmpty) {
        data.addAll({ApiKey.status: params.status!});
      }
      if (params.notes != null && params.notes!.isNotEmpty) {
        data.addAll({ApiKey.notes: params.notes!});
      }

      final response = await apiService.post(
        '${EndPoints.encounter}/$encounterId',
        headers: {"locale": locale, "Authorization": 'Bearer $token'},

        data: data,
      );

      if (response.statusCode == 200) {
        return Right(null);
      }
      final error = ErrorModel(
        status: response.statusCode,
        errorMessage: response.error?.errorMessage ?? "Unknown error",
      );
      return Left(error);
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }
}
