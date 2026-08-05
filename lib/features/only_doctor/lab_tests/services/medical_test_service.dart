import 'package:dartz/dartz.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/features/only_doctor/lab_tests/models/medical_test_list_model.dart';

class MedicalTestService {
  ApiServices apiService;
  MedicalTestService({required this.apiService});

  Future<Either<ErrorModel, MedicalTestListModel>> getMedicalTests(
    String locale,
    String? token,
  ) async {
    try {
      final response = await apiService.get(
        EndPoints.medicalTest,
        headers: {'locale': locale, 'Authorization': 'Bearer $token'},
      );

      if (response[ApiKey.status] == 1) {
        return Right(MedicalTestListModel.fromJson(response));
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }
}
