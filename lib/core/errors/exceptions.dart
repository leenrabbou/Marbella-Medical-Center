import 'package:dio/dio.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/generated/l10n.dart';

class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

class CacheException implements Exception {
  final String errorMessage;
  CacheException({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class ConflictException extends ServerException {
  ConflictException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

handleDioException(DioException e) {
  final response = e.response;
  final fallbackError = ErrorModel(
    status: response?.statusCode ?? 0,
    errorMessage: S().unknown_error,
  );

  ErrorModel errorFrom(Response? r) {
    final data = r?.data;
    return (data is Map) ? ErrorModel.fromJson(data) : fallbackError;
  }

  switch (e.type) {
    case DioExceptionType.connectionError:
      throw ConnectionErrorException(errorFrom(response));
    case DioExceptionType.badCertificate:
      throw BadCertificateException(fallbackError);
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(fallbackError);
    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(fallbackError);
    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(fallbackError);

    case DioExceptionType.badResponse:
      final errorModel = errorFrom(response);
      switch (response?.statusCode) {
        case 400:
          throw BadResponseException(errorModel);
        case 401:
          throw UnauthorizedException(errorModel);
        case 403:
          throw ForbiddenException(errorModel);
        case 404:
          throw NotFoundException(errorModel);
        case 409:
          throw ConflictException(errorModel);
        default:
          throw BadResponseException(errorModel);
      }

    case DioExceptionType.cancel:
      throw CancelException(
        ErrorModel(errorMessage: e.toString(), status: 500),
      );

    case DioExceptionType.unknown:
    case DioExceptionType.transformTimeout:
      throw UnknownException(
        ErrorModel(
          status: response?.statusCode ?? 0,
          errorMessage: e.message ?? S().unknown_error,
        ),
      );
  }
}
