import 'package:marbella/core/errors/error_model.dart';

class ApiResponse<T> {
  final int statusCode;
  final T? data;
  final ErrorModel? error;

  ApiResponse({required this.statusCode, this.data, this.error});
}
