import 'package:flutter/foundation.dart';
import 'package:marbella/features/only_doctor/audit/models/audit_model.dart';
import 'package:marbella/features/shared/encounters/models/encounter_model.dart';
import 'package:marbella/features/shared/encounters/services/encounters_service.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/generated/l10n.dart';

class EncounterViewmodel extends ChangeNotifier {
  EncountersService encountersService;
  final NetworkInfo networkInfo;
  EncounterViewmodel({
    required this.encountersService,
    required this.networkInfo,
  });

  final Map<String, int> _currentPageMap = {};
  final Map<String, bool> _hasMoreMap = {};
  final Map<String, bool> _isFetchingMap = {};
  final Map<String, bool> _isLoadingMap = {};

  List<EncounterModel> allEncounters = [];
  List<EncounterModel> arrivedEncounters = [];
  String? errorMessage;

  final Map<int, bool> _isLoadingDetailsMap = {};
  final Map<int, String?> _errorMessageDetailsMap = {};
  final Map<int, EncounterModel> _encounterDetailsMap = {};

  final Map<int, bool> _isLoadingAuditMap = {};
  final Map<int, String?> _errorMessageAuditMap = {};
  final Map<int, List<AuditModel>> _encounterAuditsMap = {};

  bool isLoadingDetailsFor(int id) => _isLoadingDetailsMap[id] ?? false;
  String? errorMessageDetailsFor(int id) => _errorMessageDetailsMap[id];
  EncounterModel? encounterDetailsFor(int id) => _encounterDetailsMap[id];

  bool isLoadingAuditFor(int id) => _isLoadingAuditMap[id] ?? true;
  String? errorMessageAuditFor(int id) => _errorMessageAuditMap[id];
  List<AuditModel>? encounterAuditFor(int id) => _encounterAuditsMap[id];

  bool isLoadingUpdate = false;
  String? errorMessageUpdate;
  bool isUpdateSuccessfully = false;

  bool get isLoading => _isLoadingMap.values.any((element) => element == true);

  String _getStatusKey(String? status) => status ?? 'all';
  bool getHasMore(String? status) =>
      _hasMoreMap[_getStatusKey(status)] ?? false;
  bool getIsFetching(String? status) =>
      _isFetchingMap[_getStatusKey(status)] ?? false;
  int getCurrentPage(String? status) =>
      _currentPageMap[_getStatusKey(status)] ?? 1;
  String? msgErrorMessage;

  List<EncounterModel> getEncountersListByStatus(String? status) {
    switch (status) {
      case 'arrived,in-progress':
        return arrivedEncounters;
      case null:
      default:
        return allEncounters;
    }
  }

  int _total = 0;
  int get total => _total;

  Future<void> getEncounters(
    String locale,
    String? token,
    EncounterParams params,
    int pageToFetch,
  ) async {
    print(params.status);
    final statusKey = _getStatusKey(params.status);
    final targetList = getEncountersListByStatus(params.status);

    if (getIsFetching(params.status) || !getHasMore(params.status)) return;

    _isFetchingMap[statusKey] = true;
    if (pageToFetch == 1) {
      _isLoadingMap[statusKey] = true;
      targetList.clear();
    }
    errorMessage = null;
    notifyListeners();

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      errorMessage = S().no_internet_message;
      _isLoadingMap[statusKey] = false;
      _isFetchingMap[statusKey] = false;
      notifyListeners();
      if (kDebugMode) print('[Patients] No network.');
      return;
    }

    final result = await encountersService.getEncounters(
      locale,
      token,
      pageToFetch,
      params,
    );
    if (token == null) {
      errorMessage = S().token_missing;
      _isLoadingMap[statusKey] = false;
      _isFetchingMap[statusKey] = false;
      notifyListeners();
      return;
    }
    result.fold(
      (failure) {
        errorMessage = failure.errorMessage;
        _hasMoreMap[statusKey] = false;
        if (kDebugMode) print('[encounters] Failed: ${failure.errorMessage}');
      },
      (response) {
        targetList.addAll(response.data.data);
        _currentPageMap[statusKey] = response.data.currentPage + 1;
        _hasMoreMap[statusKey] =
            response.data.currentPage < response.data.lastPage;
        _total = response.data.total;
        if (kDebugMode) {
          print(
            '[encounters] Page ${response.data.currentPage} loaded. '
            'Next: ${getCurrentPage(params.status)}',
          );
          print(allEncounters.length);
          print(arrivedEncounters.length);
        }
      },
    );

    _isFetchingMap[statusKey] = false;
    _isLoadingMap[statusKey] = false;
    notifyListeners();
  }

  Future<void> refreshToFetchDataList(
    String locale,
    String? token,
    EncounterParams params,
  ) async {
    final statusKey = _getStatusKey(params.status);
    _currentPageMap[statusKey] = 1;
    _hasMoreMap[statusKey] = true;
    _isFetchingMap[statusKey] = false;
    _isLoadingMap[statusKey] = false;
    errorMessage = null;
    notifyListeners();
    await getEncounters(locale, token, params, 1);
  }

  Future<void> getEncounterDetails(String locale, String? token, int id) async {
    _isLoadingDetailsMap[id] = true;
    _errorMessageDetailsMap[id] = null;
    notifyListeners();

    if (token == null) {
      _isLoadingDetailsMap[id] = false;
      _errorMessageDetailsMap[id] = S().token_missing;
      notifyListeners();
      return;
    }

    final result = await encountersService.getEncounterDetails(
      locale,
      token,
      id,
    );
    result.fold(
      (failure) {
        _errorMessageDetailsMap[id] = failure.errorMessage;
        if (kDebugMode) {
          print('[Encounter Details] Failed: ${failure.errorMessage}');
        }
      },
      (response) {
        _encounterDetailsMap[id] = response.data;
        if (kDebugMode) print('[Encounter Details] Success for id=$id');
      },
    );

    _isLoadingDetailsMap[id] = false;
    notifyListeners();
  }

  Future<bool> updateEncounter(
    UpdateEncounterParams params,
    int encounterId,
    String locale,
    String? token,
  ) async {
    isLoadingUpdate = true;
    errorMessageUpdate = null;
    isUpdateSuccessfully = false;
    notifyListeners();
    if (token == null) {
      isLoadingUpdate = false;
      notifyListeners();
      if (kDebugMode) {
        print("error");
      }
      return false;
    }
    final result = await encountersService.updateEncounters(
      locale,
      token,
      encounterId,
      params,
    );

    return result.fold(
      (failure) {
        errorMessageUpdate = failure.errorMessage;
        if (kDebugMode) {
          print("Update Encounter failed: ${failure.errorMessage}");
        }
        isLoadingUpdate = false;
        notifyListeners();
        return false;
      },
      (_) {
        isUpdateSuccessfully = true;
        final cached = _encounterDetailsMap[encounterId];
        if (cached != null) {
          _encounterDetailsMap[encounterId] = cached.copyWith(
            reason: params.reason,
            notes: params.notes,
          );
        }
        if (kDebugMode) print("Update Encounter success");
        isLoadingUpdate = false;
        notifyListeners();
        return true;
      },
    );
  }
}
