import 'package:flutter/foundation.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/observations/models/observation_model.dart';
import 'package:marbella/features/shared/observations/services/observation_service.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/generated/l10n.dart';

class ObservationViewmodel extends ChangeNotifier {
  ObservationService observationServices;
  final NetworkInfo networkInfo;
  ObservationViewmodel({
    required this.observationServices,
    required this.networkInfo,
  });
  final Map<String, List<ObservationModel>> _observationsMap = {};
  final Map<String, bool> _loadingMap = {};
  final Map<String, String?> _errorMap = {};

  bool isLoading = false;
  bool getListSuccessfully = false;
  List<ObservationModel> observations = [];
  String? errorMessage;

  bool updateisLoading = false;
  String? updateErrorMessage;

  bool addisLoading = false;
  String? addErrorMessage;

  bool deleteisLoading = false;
  String? deleteErrorMessage;

  String _keyOf(ObservationParams params) =>
      '${params.patientId}_${params.codeId}_${params.status}_${params.encounterId}';

  List<ObservationModel> observationsFor(ObservationParams params) =>
      _observationsMap[_keyOf(params)] ?? [];

  bool isLoadingFor(ObservationParams params) =>
      _loadingMap[_keyOf(params)] ?? false;

  String? errorFor(ObservationParams params) => _errorMap[_keyOf(params)];

  ObservationModel? lastObservationFor(ObservationParams params) {
    final list = observationsFor(params);
    return list.isNotEmpty ? list.first : null;
  }

  Future<void> getobservations(
    String locale,
    String? token,
    ObservationParams params,
  ) async {
    final key = _keyOf(params);
    _loadingMap[key] = true;
    _errorMap[key] = null;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    if (token == null) {
      _errorMap[key] = S().token_missing;
      errorMessage = S().token_missing;
      _loadingMap[key] = false;
      isLoading = false;
      notifyListeners();
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      _errorMap[key] = S().no_internet_message;
      errorMessage = S().no_internet_message;
      _loadingMap[key] = false;
      isLoading = false;
      notifyListeners();
      if (kDebugMode) print("Connection failed: No network.");
      return;
    }

    final result = await observationServices.getObservations(
      locale,
      token,
      params,
    );

    result.fold(
      (failure) {
        _errorMap[key] = failure.errorMessage;
        errorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("failed fetch observations${failure.errorMessage}");
        }
      },
      (response) {
        getListSuccessfully = true;
        _observationsMap[key] = response.data;
        observations = response.data;
        if (kDebugMode) print("fetch observations success");
      },
    );

    _loadingMap[key] = false;
    isLoading = false;
    notifyListeners();
  }

  Future<bool> updateObservation(
    UpdateObservationParams params,
    int observationId,
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

    final result = await observationServices.updateObservation(
      locale,
      token,
      params,
      observationId,
    );

    return result.fold(
      (failure) {
        updateErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("update observation failed: ${failure.errorMessage}");
        }
        updateisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("update observation success");
        updateisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> addObservation(
    AddObservationParams params,
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

    final result = await observationServices.addObservation(
      locale,
      token,
      params,
    );

    return result.fold(
      (failure) {
        addErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("add observation failed: ${failure.errorMessage}");
        }
        addisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("add observation success");
        addisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> deleteObservation(
    int observationId,
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

    final result = await observationServices.deleteObservation(
      locale,
      token,
      observationId,
    );

    return result.fold(
      (failure) {
        deleteErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("delete observation failed: ${failure.errorMessage}");
        }
        deleteisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("delete observation success");
        deleteisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}
