import 'package:marbella/core/databases/api/end_points.dart';
import 'package:marbella/features/shared/codes/models/code_model.dart';

class CodeListModel {
  final int status;
  final List<CodeModel> data;
  final String message;

  CodeListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CodeListModel.fromJson(Map<String, dynamic> jsonData) {
    return CodeListModel(
      status: jsonData[ApiKey.status],
      message: jsonData[ApiKey.message],
      data: List.from(
        jsonData[ApiKey.data],
      ).map((val) => CodeModel.fromJson(val)).toList(),
    );
  }
}
