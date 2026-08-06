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
    T Function(Map<String, dynamic>) parser, {
    required String dataKey,
  }) {
    final dataMap = json[ApiKey.data] as Map<String, dynamic>;
    return InteractionListModel<T>(
      status: json[ApiKey.status],
      message: json[ApiKey.message],
      data: (dataMap[dataKey] as List)
          .map((e) => parser(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
