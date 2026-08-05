import 'package:dartz/dartz.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/features/only_doctor/nurses/models/encounter_nurses_list_model.dart';
import 'package:marbella/generated/l10n.dart';

class EncounterNursesServices {
  ApiServices apiService;
  EncounterNursesServices({required this.apiService});

  Future<Either<ErrorModel, EncounterNursesListModel>> getAllNurses(
    String locale,
    String? token,
    int page,
  ) async {
    try {
      String url = "${EndPoints.nurse}?page=$page";
      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );
      if (response[ApiKey.status] == 1) {
        final data = EncounterNursesListModel.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, EncounterNursesListModel>> getEncounterNurses(
    String locale,
    String? token,
    int page,
    int encounterId,
  ) async {
    try {
      String url = "${EndPoints.encounterNurses}/$encounterId?page=$page";
      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );
      if (response[ApiKey.status] == 1) {
        final data = EncounterNursesListModel.fromJson(response);

        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> addNurseToEncounter(
    String locale,
    String token,
    int encounterId,
    int employeeId,
  ) async {
    try {
      final response = await apiService.post(
        EndPoints.encounterNurse,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},

        data: {ApiKey.encounterId: encounterId, ApiKey.employeeId: employeeId},
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

  Future<Either<ErrorModel, void>> deleteEncounterNurse(
    String locale,
    String token,
    int encounterId,
    int nurseId,
  ) async {
    try {
      final response = await apiService.delete(
        '${EndPoints.encounterNurse}/$nurseId/${EndPoints.encounter}/$encounterId',
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
