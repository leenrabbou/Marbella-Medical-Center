import 'package:flutter/foundation.dart';
import 'package:marbella/features/only_doctor/audit/models/audit_model.dart';
import 'package:marbella/features/only_doctor/audit/service/audit_service.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/generated/l10n.dart';

class AuditViewmodel extends ChangeNotifier {
  AuditService auditService;
  final NetworkInfo networkInfo;
  AuditViewmodel({required this.auditService, required this.networkInfo});

  final Map<int, bool> _isLoadingAuditMap = {};
  final Map<int, String?> _errorMessageAuditMap = {};
  final Map<int, List<AuditModel>> _auditsMap = {};

  bool isLoadingAuditFor(int id) => _isLoadingAuditMap[id] ?? false;
  String? errorMessageAuditFor(int id) => _errorMessageAuditMap[id];
  List<AuditModel>? auditFor(int id) => _auditsMap[id];

  Future<void> getAudit(
    String locale,
    String? token,
    int id,
    String endPoint,
  ) async {
    _isLoadingAuditMap[id] = true;
    _errorMessageAuditMap[id] = null;
    notifyListeners();

    if (token == null) {
      _isLoadingAuditMap[id] = false;
      _errorMessageAuditMap[id] = S().token_missing;
      notifyListeners();
      return;
    }

    final result = await auditService.getAudit(locale, token, id, endPoint);
    result.fold(
      (failure) {
        _errorMessageAuditMap[id] = failure.errorMessage;
        if (kDebugMode) {
          print('[$endPoint Audit] Failed: ${failure.errorMessage}');
        }
      },
      (response) {
        _auditsMap[id] = response.data;
        if (kDebugMode) print('[$endPoint Audit] Success for id=$id');
      },
    );

    _isLoadingAuditMap[id] = false;
    notifyListeners();
  }
}
