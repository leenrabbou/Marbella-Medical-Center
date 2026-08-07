import 'package:dartz/dartz.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/features/only_doctor/audit/models/audit_list_model.dart';

class AuditService {
  ApiServices apiService;
  AuditService({required this.apiService});
  Future<Either<ErrorModel, AuditListModel>> getAudit(
    String locale,
    String? token,
    int id,
    String endPoint,
  ) async {
    try {
      final response = await apiService.get(
        "$endPoint/$id/${EndPoints.audit}",
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
      );

      if (response[ApiKey.status] == 1) {
        final data = AuditListModel.fromJson(response);

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
