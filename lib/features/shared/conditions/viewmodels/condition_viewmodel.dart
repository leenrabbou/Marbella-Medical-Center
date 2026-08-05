import 'package:flutter/foundation.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/conditions/models/condition_model.dart';
import 'package:marbella/features/shared/conditions/service/condition_service.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/generated/l10n.dart';

class ConditionViewmodel extends ChangeNotifier {
  ConditionService conditionService;
  final NetworkInfo networkInfo;
  ConditionViewmodel({
    required this.conditionService,
    required this.networkInfo,
  });

  final Map<String, bool> _isLoadingMap = {};
  final Map<String, bool> _getListSuccessfullyMap = {};
  final Map<String, String?> _errorMessageMap = {};
  final Map<String, List<ConditionModel>> _encounterConditionsByKey = {};
  String _buildKey(ConditionParams params) {
    return [
      params.patientId?.toString() ?? '-',
      params.encounterId?.toString() ?? '-',
      params.clinicalStatus ?? 'all',
      params.verificationStatus ?? 'all',
    ].join('|');
  }

  List<ConditionModel> conditionsFor(ConditionParams params) =>
      _encounterConditionsByKey[_buildKey(params)] ?? [];

  bool isLoadingFor(ConditionParams params) =>
      _isLoadingMap[_buildKey(params)] ?? false;

  String? errorMessageFor(ConditionParams params) =>
      _errorMessageMap[_buildKey(params)];

  bool getListSuccessfullyFor(ConditionParams params) =>
      _getListSuccessfullyMap[_buildKey(params)] ?? false;

  bool updateisLoading = false;
  String? updateErrorMessage;

  bool addisLoading = false;
  String? addErrorMessage;

  bool deleteisLoading = false;
  String? deleteErrorMessage;

  Future<void> getEncounterConditions(
    String locale,
    String? token,
    ConditionParams params,
  ) async {
    final key = _buildKey(params);

    _isLoadingMap[key] = true;
    _errorMessageMap[key] = null;
    _encounterConditionsByKey[key] = [];
    notifyListeners();

    if (token == null) {
      _errorMessageMap[key] = S().token_missing;
      _isLoadingMap[key] = false;
      notifyListeners();
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      _errorMessageMap[key] = S().no_internet_message;
      _isLoadingMap[key] = false;
      notifyListeners();
      return;
    }

    final result = await conditionService.getConditions(locale, token, params);

    result.fold(
      (failure) {
        _errorMessageMap[key] = failure.errorMessage;
        if (kDebugMode) {
          print("failed fetch encounter conditions: ${failure.errorMessage}");
        }
      },
      (response) {
        _getListSuccessfullyMap[key] = true;
        _encounterConditionsByKey[key] = response.data;
        if (kDebugMode) print("fetch encounter conditions success");
      },
    );

    _isLoadingMap[key] = false;
    notifyListeners();
  }

  Future<bool> updateCondition(
    UpdateConditionParams params,
    int conditionId,
    String locale,
    String? token,
  ) async {
    updateisLoading = true;
    updateErrorMessage = null;
    notifyListeners();
    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      updateErrorMessage = S().no_internet_message;
      updateisLoading = false;
      notifyListeners();
      return false;
    }
    if (token == null) {
      updateErrorMessage = S().token_missing;
      updateisLoading = false;
      notifyListeners();
      return false;
    }

    final result = await conditionService.updateCondition(
      locale,
      token,
      params,
      conditionId,
    );

    return result.fold(
      (failure) {
        updateErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("update Condition failed: ${failure.errorMessage}");
        }
        updateisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("update Condition success");
        updateisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> addCondition(
    AddConditionParams params,
    String locale,
    String? token,
  ) async {
    addisLoading = true;
    addErrorMessage = null;
    notifyListeners();

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      addErrorMessage = S().no_internet_message;
      addisLoading = false;
      notifyListeners();
      return false;
    }
    if (token == null) {
      addErrorMessage = S().token_missing;
      addisLoading = false;
      notifyListeners();
      return false;
    }

    final result = await conditionService.addCondition(locale, token, params);

    return result.fold(
      (failure) {
        addErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("add Condition failed: ${failure.errorMessage}");
        }
        addisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("add Condition success");
        addisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> deleteCondition(
    int conditionId,
    String locale,
    String? token,
  ) async {
    deleteisLoading = true;
    deleteErrorMessage = null;
    notifyListeners();
    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      deleteErrorMessage = S().no_internet_message;
      deleteisLoading = false;
      notifyListeners();
      return false;
    }
    if (token == null) {
      deleteErrorMessage = S().token_missing;
      deleteisLoading = false;
      notifyListeners();
      return false;
    }

    final result = await conditionService.deleteCondition(
      locale,
      token,
      conditionId,
    );

    return result.fold(
      (failure) {
        deleteErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("delete Condition failed: ${failure.errorMessage}");
        }
        deleteisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("delete Condition success");
        deleteisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}
