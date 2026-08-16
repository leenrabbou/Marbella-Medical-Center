import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PerformanceInterceptor extends Interceptor {
  final Map<RequestOptions, DateTime> _startTimeMap = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTimeMap[options] = DateTime.now();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = _startTimeMap.remove(response.requestOptions);
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      if (kDebugMode) {
        print(
          '⚡ [PERFORMANCE] ${response.requestOptions.method} ${response.requestOptions.path}',
        );
        print('⏱️ Execution Time: $duration ms');
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _startTimeMap.remove(err.requestOptions);
    super.onError(err, handler);
  }
}
