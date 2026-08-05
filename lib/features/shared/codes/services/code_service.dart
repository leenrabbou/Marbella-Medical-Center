import 'package:dartz/dartz.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/codes/models/code_list_model.dart';
import 'package:marbella/features/shared/codes/models/code_model.dart';

class CodeService {
  ApiServices apiService;
  CodeService({required this.apiService});

  Future<Either<ErrorModel, CodeListModel>> getCodes(
    String locale,
    String token,
    CodeParams params,
  ) async {
    try {
      final Map<String, String> queryParams = {};

      if (params.active != null) {
        queryParams['filter[active]'] = params.active.toString();
      }

      queryParams['filter[category]'] = params.category;

      final response = await apiService.get(
        EndPoints.code,
        headers: {'locale': locale, 'Authorization': 'Bearer $token'},
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response[ApiKey.status] == 1) {
        return Right(CodeListModel.fromJson(response));
      }
      return Left(ErrorModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }

  Future<Either<ErrorModel, CodeModel>> addCode(
    String locale,
    String token,
    AddCodeParams params,
  ) async {
    try {
      final response = await apiService.post(
        EndPoints.code,
        headers: {"locale": locale, "Authorization": 'Bearer $token'},
        data: {
          ApiKey.system: params.system,
          ApiKey.code: params.code,
          ApiKey.display: params.display,
          ApiKey.category: params.category,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        final codeJson = data is Map && data.containsKey(ApiKey.data)
            ? data[ApiKey.data]
            : data;

        final newCode = CodeModel.fromJson(codeJson);
        return Right(newCode);
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
