import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/core/databases/api/performance_interceptor.dart';
import 'package:marbella/core/errors/api_response.dart';
import 'package:marbella/core/errors/error_model.dart';
import 'package:marbella/core/errors/exceptions.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_token_provider.dart';
import 'package:marbella/generated/l10n.dart';

typedef UnauthorizedCallback = void Function();

class ApiServices {
  final Dio dio;
  final UnauthorizedCallback? onUnauthorized;
  final AuthTokenProvider tokenProvider;

  ApiServices({
    required this.dio,
    this.onUnauthorized,
    required this.tokenProvider,
  }) {
    dio.options.baseUrl = EndPoints.baseUrl;
    dio.options.headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 20);
    dio.options.sendTimeout = const Duration(seconds: 20);
    dio.interceptors.add(PerformanceInterceptor());
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, handler) {
          if (error.response?.statusCode == 401) {
            onUnauthorized?.call();
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<ApiResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      dynamic requestData;

      if (isFormData) {
        requestData = data is FormData ? data : FormData.fromMap(data);
      } else {
        requestData = data;
      }

      final res = await dio.post(
        path,
        data: requestData,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return ApiResponse(statusCode: res.statusCode ?? 0, data: res.data);
    } on DioException catch (e) {
      final status = e.response?.statusCode ?? 0;
      final body = e.response?.data;
      final errorModel = (body is Map)
          ? ErrorModel.fromJson(body)
          : ErrorModel(status: status, errorMessage: S().unknown_error);
      return ApiResponse(statusCode: status, error: errorModel);
    }
  }

  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      var res = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  Future delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      var res = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return res;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool isFormData = false,
  }) async {
    try {
      var res = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  Future<Uint8List> getBytes(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      var res = await dio.get<Uint8List>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers, responseType: ResponseType.bytes),
      );
      if (res.data == null) {
        throw DioException(
          requestOptions: res.requestOptions,
          response: res,
          message: 'Received empty response for bytes',
        );
      }
      return res.data!;
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to fetch bytes: $e');
    }
  }
}
