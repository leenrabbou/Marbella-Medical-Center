import 'package:marbella/core/databases/api/end_points.dart';

class InteractionListModel<T> {
  final int status;
  final List<T> data;
  final String message;

  InteractionListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory InteractionListModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) parser,
  ) {
    final dataList = json[ApiKey.data] as List;

    return InteractionListModel<T>(
      status: json[ApiKey.status] as int,
      message: json[ApiKey.message] as String,
      data: dataList.map((e) => parser(e as Map<String, dynamic>)).toList(),
    );
  }
}
