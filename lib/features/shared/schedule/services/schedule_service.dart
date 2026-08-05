import 'package:dartz/dartz.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/databases/cache/cache_service.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/features/shared/schedule/models/schedule_response_model.dart';

class ScheduleService {
  final ApiServices apiService;
  final CacheService cacheService;
  ScheduleService({required this.apiService, required this.cacheService});
  Future<Either<ErrorModel, ScheduleResponseModel>> getSchedule(
    String locale,
    String token,
  ) async {
    try {
      final response = await apiService.get(
        EndPoints.getSchedule,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );
      if (response[ApiKey.status] == 1) {
        final data = ScheduleResponseModel.fromJson(response);
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
