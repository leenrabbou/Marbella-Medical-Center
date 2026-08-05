import 'package:dartz/dartz.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/conditions/models/condition_list_model.dart';
import 'package:marbella/generated/l10n.dart';

class ConditionService {
  ApiServices apiService;
  ConditionService({required this.apiService});

  Future<Either<ErrorModel, ConditionListModel>> getConditions(
    String locale,
    String? token,
    ConditionParams params,
  ) async {
    try {
      String url = EndPoints.condition;
      Map<String, dynamic> queryParameters = {
        if (params.encounterId != null)
          'filter[encounter_id]': params.encounterId!.toString(),

        if (params.patientId != null)
          'filter[patient_id]': params.patientId!.toString(),

        if (params.clinicalStatus != null && params.clinicalStatus!.isNotEmpty)
          'filter[clinical_status]': params.clinicalStatus!.toString(),

        if (params.verificationStatus != null &&
            params.verificationStatus!.isNotEmpty)
          'filter[verification_status]': params.verificationStatus!.toString(),
      };
      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        queryParameters: queryParameters,
      );

      if (response[ApiKey.status] == 1) {
        final data = ConditionListModel.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> updateCondition(
    String locale,
    String token,
    UpdateConditionParams params,
    int conditionId,
  ) async {
    try {
      final response = await apiService.post(
        '${EndPoints.condition}/$conditionId',
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        data: {
          ApiKey.codeId: params.codeId,
          ApiKey.clinicalStatus: params.clinicalStatus,
          ApiKey.verificationStatus: params.verificationStatus,
          ApiKey.onsetDate: params.onsetDate,
          ApiKey.abatementDate: params.abatementDate,
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

  Future<Either<ErrorModel, void>> addCondition(
    String locale,
    String token,
    AddConditionParams params,
  ) async {
    try {
      final response = await apiService.post(
        EndPoints.condition,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},

        data: {
          ApiKey.encounterId: params.encounterId,
          ApiKey.codeId: params.codeId,
          ApiKey.clinicalStatus: params.clinicalStatus,
          ApiKey.verificationStatus: params.verificationStatus,
          ApiKey.onsetDate: params.onsetDate,
          ApiKey.abatementDate: params.abatementDate,
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

  Future<Either<ErrorModel, void>> deleteCondition(
    String locale,
    String token,
    int conditionId,
  ) async {
    try {
      final response = await apiService.delete(
        '${EndPoints.condition}/$conditionId',
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
