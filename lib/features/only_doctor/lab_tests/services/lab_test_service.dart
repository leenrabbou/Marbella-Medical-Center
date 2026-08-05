import 'package:dartz/dartz.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/lab_tests/models/lab_test_details_model.dart';
import 'package:marbella/features/only_doctor/lab_tests/models/lab_test_list_model.dart';
import 'package:marbella/generated/l10n.dart';

class LabTestService {
  ApiServices apiService;
  LabTestService({required this.apiService});

  Future<Either<ErrorModel, LabTestListModel>> getLabTests(
    String locale,
    String? token,
    int page,
    LabTestParams params,
  ) async {
    try {
      final Map<String, String> queryParams = {'page': page.toString()};

      if (params.patientId != null) {
        queryParams['filter[patient_id]'] = params.patientId.toString();
      }
      if (params.status != null) {
        queryParams['filter[status]'] = params.status!;
      }

      final response = await apiService.get(
        EndPoints.patientLabTest,
        headers: {'locale': locale, 'Authorization': 'Bearer $token'},
        queryParameters: queryParams,
      );

      if (response[ApiKey.status] == 1) {
        return Right(LabTestListModel.fromJson(response));
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, LabTestDetailsModel>> getLabTestDetails(
    String locale,
    String? token,
    int id,
  ) async {
    try {
      final response = await apiService.get(
        '${EndPoints.patientLabTest}/$id',
        headers: {'locale': locale, 'Authorization': 'Bearer $token'},
      );

      if (response[ApiKey.status] == 1) {
        return Right(LabTestDetailsModel.fromJson(response));
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> addPatientLabTest(
    String locale,
    String token,
    AddPatientLabTestParams params,
  ) async {
    try {
      final response = await apiService.post(
        EndPoints.patientLabTest,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        data: {
          ApiKey.patientId: params.patientId,
          ApiKey.medicalTestId: params.medicalTestId,
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

  Future<Either<ErrorModel, void>> deletePatientLabTest(
    String locale,
    String token,
    int labTestId,
  ) async {
    try {
      final response = await apiService.delete(
        '${EndPoints.patientLabTest}/$labTestId',
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
