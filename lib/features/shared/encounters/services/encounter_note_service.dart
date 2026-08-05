import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/encounters/models/encounter_notes_list_model.dart';
import 'package:marbella/generated/l10n.dart';

class EncounterNoteService {
  ApiServices apiService;
  EncounterNoteService({required this.apiService});

  Future<Either<ErrorModel, EncounterNotesListModel>> getEncounterNotes(
    String locale,
    String? token,
    EncounterNoteParams params,
  ) async {
    try {
      String url = EndPoints.encounterNote;
      Map<String, dynamic> queryParameters = {
        if (params.encounterId != null)
          'filter[encounter_id]': params.encounterId!.toString(),

        if (params.patientId != null)
          'filter[patient_id]': params.patientId!.toString(),

        if (params.status != null && params.status!.isNotEmpty)
          'filter[status]': params.status!,
      };
      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        queryParameters: queryParameters,
      );

      if (response[ApiKey.status] == 1) {
        final data = EncounterNotesListModel.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> updateEncounterNote(
    String locale,
    String token,
    UpdateEncounterNoteParams params,
    int encounterNoteId,
  ) async {
    try {
      FormData formData = FormData();

      formData.fields.addAll([
        if (params.title != null && params.title!.isNotEmpty)
          MapEntry(ApiKey.title, params.title!),
        if (params.note != null && params.note!.isNotEmpty)
          MapEntry(ApiKey.note, params.note!),
        if (params.durationUnit != null && params.durationUnit!.isNotEmpty)
          MapEntry(ApiKey.durationUnit, params.durationUnit!),
        if (params.durationValue != null)
          MapEntry(ApiKey.durationValue, params.durationValue.toString()),
        MapEntry('_method', 'patch'),
      ]);

      final response = await apiService.post(
        '${EndPoints.encounterNote}/$encounterNoteId',
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

  Future<Either<ErrorModel, void>> addEncounterNote(
    String locale,
    String token,
    AddEncounterNoteParams params,
  ) async {
    try {
      FormData formData = FormData();

      formData.fields.addAll([
        MapEntry(ApiKey.encounterId, params.encounterId.toString()),
        if (params.title != null && params.title!.isNotEmpty)
          MapEntry(ApiKey.title, params.title!),
        if (params.note != null && params.note!.isNotEmpty)
          MapEntry(ApiKey.note, params.note!),
        if (params.durationUnit != null && params.durationUnit!.isNotEmpty)
          MapEntry(ApiKey.durationUnit, params.durationUnit!),
        if (params.durationValue != null)
          MapEntry(ApiKey.durationValue, params.durationValue.toString()),
      ]);

      final response = await apiService.post(
        EndPoints.encounterNote,
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

  Future<Either<ErrorModel, void>> deleteEncounterNote(
    String locale,
    String token,
    int encounterNoteId,
  ) async {
    try {
      final response = await apiService.delete(
        '${EndPoints.encounterNote}/$encounterNoteId',
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
