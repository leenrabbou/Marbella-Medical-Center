import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/medications/models/interaction_list_model.dart';
import 'package:marbella/generated/l10n.dart';

class InteractionService {
  ApiServices apiService;
  InteractionService({required this.apiService});

  Future<Either<ErrorModel, InteractionListModel<T>>> getInteractions<T>(
    String locale,
    String? token,
    T Function(Map<String, dynamic>) parser,
    InteractionParams params,
  ) async {
    try {
      String url = EndPoints.medicationInteraction;
      Map<String, dynamic> queryParameters = {
        'filter[medication_id]': params.medicationId.toString(),
        'filter[interactable_type]': params.interactableType,
      };

      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        queryParameters: queryParameters,
      );

      if (response[ApiKey.status] == 1) {
        final data = InteractionListModel<T>.fromJson(
          response,
          parser,
          dataKey: ApiKey.data,
        );
        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> addInteraction(
    String locale,
    String token,
    AddInteractionParams params,
  ) async {
    try {
      FormData formData = FormData();

      formData.fields.addAll([
        MapEntry(ApiKey.medicationId, params.medicationId.toString()),
        MapEntry(ApiKey.interactableType, params.interactableType),
        MapEntry(ApiKey.interactableId, params.interactableId.toString()),

        MapEntry(ApiKey.severity, params.severity),
        if (params.description != null)
          MapEntry(ApiKey.description, params.description!),
      ]);

      final response = await apiService.post(
        EndPoints.medicationInteraction,
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

  Future<Either<ErrorModel, void>> deleteInteraction(
    String locale,
    String token,
    int interactionId,
  ) async {
    try {
      final response = await apiService.delete(
        '${EndPoints.medicationInteraction}/$interactionId',
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
