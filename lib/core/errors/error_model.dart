import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/generated/l10n.dart';

class ErrorModel {
  int? status;
  final String errorMessage;

  ErrorModel({this.status, required this.errorMessage});
  factory ErrorModel.fromJson(Map jsonData) {
    dynamic message = jsonData[ApiKey.message];
    String messageText = '';

    if (message is String) {
      messageText = message;
    } else if (message is Map) {
      messageText = message.values
          .map((e) => (e is List ? e.join('\n') : e.toString()))
          .join('\n');
    } else if (message is List) {
      if (message.isEmpty) {
        messageText = "";
      } else {
        messageText = message.join('\n');
      }
    } else if (message == null) {
      messageText = S().unknown_error;
    }

    return ErrorModel(errorMessage: messageText);
  }
}
