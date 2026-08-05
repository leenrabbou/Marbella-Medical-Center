import 'package:dartz/dartz.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/databases/cache/cache_service.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/features/shared/profile/models/profile_response_model.dart';

class ProfileService {
  final ApiServices apiService;
  final CacheService cacheService;
  ProfileService({required this.apiService, required this.cacheService});
  Future<Either<ErrorModel, ProfileResponseModel>> getProfile(
    String locale,
    String token,
  ) async {
    try {
      final response = await apiService.get(
        EndPoints.getProfile,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );
      if (response[ApiKey.status] == 1) {
        final data = ProfileResponseModel.fromJson(response);
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
