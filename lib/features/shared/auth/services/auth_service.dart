import 'dart:convert';

import 'package:marbella/core/databases/cache/secure_storage_service.dart';
import 'package:marbella/features/shared/auth/models/auth_response_model.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/databases/cache/cache_keys.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/features/shared/auth/models/user_model.dart';
import 'package:dartz/dartz.dart';

class AuthService {
  final ApiServices apiService;
  final SecureStorageService secureStorage;

  AuthService({required this.apiService, required this.secureStorage});

  Future<Either<ErrorModel, AuthResponseModel>> logIn(
    LoginParams params,
    String locale,
  ) async {
    try {
      final response = await apiService.post(
        EndPoints.login,
        data: {
          ApiKey.phoneNumber: params.phoneNumber,
          ApiKey.password: params.password,
        },
      );

      if (response.statusCode == 200) {
        final AuthResponseModel res = AuthResponseModel.fromJson(response.data);

        await secureStorage.write(
          key: CacheKeys.userKey,
          value: json.encode(res.data?.toJson()),
        );
        return Right(res);
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

  Future<Either<ErrorModel, UserModel>> loadCachedUser() async {
    final dataString = await secureStorage.read(key: CacheKeys.userKey);

    if (dataString != null) {
      final dataMap = jsonDecode(dataString) as Map<String, dynamic>;
      return Right(UserModel.fromJson(dataMap));
    } else {
      return Left(
        ErrorModel(status: 0, errorMessage: S().no_cached_login_data),
      );
    }
  }

  Future<void> updateUserData(UserModel? user) async {
    secureStorage.delete(key: CacheKeys.userKey);
    await secureStorage.write(
      key: CacheKeys.userKey,
      value: json.encode(user?.toJson()),
    );
  }

  Future<Either<ErrorModel, void>> logOut(String locale, String token) async {
    try {
      await apiService.get(
        EndPoints.logout,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    } finally {
      await secureStorage.deleteAll();
    }

    return const Right(null);
  }

  Future<void> clearLocalSession() async {
    await secureStorage.deleteAll();
  }
}
