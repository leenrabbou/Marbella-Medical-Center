import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:dartz/dartz.dart';

class VerificationService {
  final ApiServices apiService;

  VerificationService({required this.apiService});

  Future<Either<ErrorModel, void>> getVerificationCode(
    String locale,
    String token,
  ) async {
    try {
      final response = await apiService.get(
        EndPoints.getVerificationCode,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );

      if (response[ApiKey.status] == 1) {
        return Right(null);
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> verifyPhone(
    String locale,
    String token,
    String otp,
  ) async {
    try {
      final response = await apiService.post(
        EndPoints.getVerificationCode,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        data: {ApiKey.otp: otp},
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
