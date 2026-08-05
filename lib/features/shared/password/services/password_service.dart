import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/cache/cache_service.dart';
import 'package:dartz/dartz.dart';

class PasswordService {
  final ApiServices apiService;
  final CacheService cacheService;

  PasswordService({required this.apiService, required this.cacheService});

  Future<Either<ErrorModel, void>> changePassword(
    String locale,
    String token,
    ChangePasswordParams params,
  ) async {
    try {
      final response = await apiService.post(
        EndPoints.changePassword,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        data: {
          ApiKey.oldPassword: params.oldPassword,
          ApiKey.newPassword: params.newPassword,
        },
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

  Future<Either<ErrorModel, void>> forgetPassword(
    String locale,
    String phoneNumber,
  ) async {
    try {
      final response = await apiService.post(
        EndPoints.forgetPassword,
        headers: {"locale": locale},
        data: {ApiKey.phoneNumber: phoneNumber},
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

  Future<Either<ErrorModel, void>> checkOtp(
    String locale,
    CheckOtpParams params,
  ) async {
    try {
      final response = await apiService.post(
        EndPoints.checkOtp,
        headers: {"locale": locale},
        data: {ApiKey.phoneNumber: params.phoneNumber, ApiKey.otp: params.otp},
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

  Future<Either<ErrorModel, void>> resetPassword(
    String locale,
    ResetPasswordParams params,
  ) async {
    try {
      final response = await apiService.post(
        EndPoints.resetPassword,
        headers: {"locale": locale},
        data: {
          ApiKey.phoneNumber: params.phoneNumber,
          ApiKey.otp: params.otp,
          ApiKey.password: params.password,
        },
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
