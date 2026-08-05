import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/patients/models/index/patients_list_model.dart';
import 'package:marbella/features/only_doctor/patients/models/show/patient_response_model.dart';
import 'package:marbella/generated/l10n.dart';

class PatientsService {
  ApiServices apiService;
  PatientsService({required this.apiService});
  Future<Either<ErrorModel, PatientsListModel>> getPatients(
    String locale,
    String? token,
    int page,
    PatientsParams params,
  ) async {
    try {
      String url = "${EndPoints.getPatients}?page=$page";
      params.search != null
          ? url = '$url&filter[search]=${params.search}'
          : null;
      final response = await apiService.get(
        url,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );
      if (response[ApiKey.status] == 1) {
        final data = PatientsListModel.fromJson(response);
        return Right(data);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, Uint8List>> getFile(
    String locale,
    String? token,
    String imgUrl,
  ) async {
    try {
      final response = await apiService.getBytes(
        imgUrl,
        headers: {
          "Accept": "image/*",
          "locale": locale,
          "Authorization": 'Bearer $token',
        },
      );
      if (response.isNotEmpty) {
        if (kDebugMode) {
          print("file fetched succesfully.");
        }
        return Right(response);
      }
      return Left(ErrorModel(errorMessage: S().failed_to_fetch, status: 0));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, PatientResponseModel>> getPatientDetails(
    String locale,
    String? token,
    int id,
  ) async {
    try {
      final response = await apiService.get(
        "${EndPoints.getPatients}/$id",
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );
      if (response[ApiKey.status] == 1) {
        final data = PatientResponseModel.fromJson(response);
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
