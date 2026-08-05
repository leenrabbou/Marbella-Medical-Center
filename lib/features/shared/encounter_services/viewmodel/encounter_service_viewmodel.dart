import 'package:marbella/features/only_doctor/appointments/models/service_model.dart';
import 'package:marbella/features/shared/encounter_services/models/encounter_service_model.dart';
import 'package:marbella/features/shared/encounter_services/services/encounter_services_service.dart';
import 'package:flutter/foundation.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/generated/l10n.dart';

class EncounterServiceViewmodel extends ChangeNotifier {
  EncounterServicesService encounterServicesService;
  final NetworkInfo networkInfo;
  EncounterServiceViewmodel({
    required this.encounterServicesService,
    required this.networkInfo,
  });

  final Map<String, bool> _isLoadingMap = {};
  final Map<String, bool> _getListSuccessfullyMap = {};
  final Map<String, String?> _errorMessageMap = {};
  final Map<String, List<EncounterServiceModel>> _medicationsByKey = {};

  bool updateisLoading = false;
  String? updateErrorMessage;

  bool addisLoading = false;
  String? addErrorMessage;

  bool deleteisLoading = false;
  String? deleteErrorMessage;

  List<ServiceModel> allServicesList = [];
  bool isLoadingAllServices = false;
  String? allServicesErrorMessage;
  bool? getallServicesSuccessfully = false;

  String _buildKey(EncounterServiceParams params) {
    return [
      params.encounterId?.toString() ?? '-',
      params.status ?? 'all',
    ].join('|');
  }

  List<EncounterServiceModel> servicesFor(EncounterServiceParams params) =>
      _medicationsByKey[_buildKey(params)] ?? [];

  bool isLoadingFor(EncounterServiceParams params) =>
      _isLoadingMap[_buildKey(params)] ?? false;

  String? errorMessageFor(EncounterServiceParams params) =>
      _errorMessageMap[_buildKey(params)];

  bool getListSuccessfullyFor(EncounterServiceParams params) =>
      _getListSuccessfullyMap[_buildKey(params)] ?? false;

  Future<void> getEncounterServices(
    String locale,
    String? token,
    EncounterServiceParams params,
  ) async {
    final key = _buildKey(params);

    _isLoadingMap[key] = true;
    _errorMessageMap[key] = null;
    _medicationsByKey[key] = [];
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

    final result = await encounterServicesService.getEncounterServices(
      locale,
      token,
      params,
    );

    result.fold(
      (failure) {
        _errorMessageMap[key] = failure.errorMessage;
        if (kDebugMode) {
          print(
            "failed fetch Encounter Services for $key: ${failure.errorMessage}",
          );
        }
      },
      (response) {
        _getListSuccessfullyMap[key] = true;
        _medicationsByKey[key] = response.data;
        if (kDebugMode) print("fetch Encounter Services success for $key");
      },
    );

    _isLoadingMap[key] = false;
    notifyListeners();
  }

  Future<bool> updateEncounterService(
    UpdateEncounterServiceParams params,
    int encounterServiceId,
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

    final result = await encounterServicesService.updateEncounterService(
      locale,
      token,
      params,
      encounterServiceId,
    );

    return result.fold(
      (failure) {
        updateErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("update Encounter Services failed: ${failure.errorMessage}");
        }
        updateisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("update Encounter Services success");
        updateisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> addEncounterService(
    AddEncounterServiceParams params,
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

    final result = await encounterServicesService.addEncounterService(
      locale,
      token,
      params,
    );

    return result.fold(
      (failure) {
        addErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("add Encounter Services failed: ${failure.errorMessage}");
        }
        addisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("add Encounter Services success");
        addisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> deleteEncounterService(
    int encounterServiceId,
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

    final result = await encounterServicesService.deleteEncounterService(
      locale,
      token,
      encounterServiceId,
    );

    return result.fold(
      (failure) {
        deleteErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("delete Encounter Services failed: ${failure.errorMessage}");
        }
        deleteisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("delete Encounter Services success");
        deleteisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<void> getAllServicesList(String locale, String? token) async {
    isLoadingAllServices = false;
    allServicesErrorMessage = null;
    allServicesList = [];
    notifyListeners();

    if (token == null) {
      allServicesErrorMessage = S().token_missing;
      isLoadingAllServices = false;
      notifyListeners();
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      allServicesErrorMessage = S().no_internet_message;
      isLoadingAllServices = false;
      notifyListeners();
      return;
    }

    final result = await encounterServicesService.getAllServicesList(
      locale,
      token,
    );

    result.fold(
      (failure) {
        allServicesErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("failed fetch all Services: ${failure.errorMessage}");
        }
      },
      (response) {
        getallServicesSuccessfully = true;
        allServicesList = response.data;
        if (kDebugMode) print("fetch all Services success.");
      },
    );

    isLoadingAllServices = false;
    notifyListeners();
  }
}
