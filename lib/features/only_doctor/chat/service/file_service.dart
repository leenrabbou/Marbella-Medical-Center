import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/generated/l10n.dart';

class FileService {
  final Dio dio;

  FileService({required this.dio});

  Future<Either<ErrorModel, Uint8List>> getFile(
    String locale,
    String token,
    String url,
  ) async {
    try {
      final response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {"locale": locale, "Authorization": 'Bearer $token'},
        ),
      );

      if (response.data == null || response.data!.isEmpty) {
        return Left(ErrorModel(status: 0, errorMessage: S().unknown_error));
      }

      return Right(Uint8List.fromList(response.data!));
    } on DioException catch (e) {
      return Left(
        ErrorModel(
          status: e.response?.statusCode ?? 0,
          errorMessage: e.message ?? S().unknown_error,
        ),
      );
    } on ServerException catch (e) {
      return Left(e.errorModel);
    } catch (e) {
      return Left(ErrorModel(status: 0, errorMessage: e.toString()));
    }
  }
}
