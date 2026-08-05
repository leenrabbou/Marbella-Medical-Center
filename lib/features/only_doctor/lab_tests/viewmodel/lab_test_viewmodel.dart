import 'package:flutter/foundation.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/lab_tests/models/lab_test_model.dart';
import 'package:marbella/features/only_doctor/lab_tests/services/lab_test_service.dart';
import 'package:marbella/generated/l10n.dart';

class LabTestViewmodel extends ChangeNotifier {
  LabTestService labTestService;
  final NetworkInfo networkInfo;
  LabTestViewmodel({required this.labTestService, required this.networkInfo});

  final Map<String, List<LabTestModel>> _labTestsByKey = {};
  final Map<String, bool> _isLoadingMap = {};
  final Map<String, bool> _isLoadingMoreMap = {};
  final Map<String, String?> _errorMap = {};
  final Map<String, int> _currentPageMap = {};
  final Map<String, bool> _hasMoreMap = {};

  String _buildListKey(LabTestParams params) =>
      '${params.patientId?.toString() ?? '-'}|${params.status ?? 'all'}';

  List<LabTestModel> labTestsFor(LabTestParams params) =>
      _labTestsByKey[_buildListKey(params)] ?? [];

  bool isLoadingFor(LabTestParams params) =>
      _isLoadingMap[_buildListKey(params)] ?? false;

  bool isLoadingMoreFor(LabTestParams params) =>
      _isLoadingMoreMap[_buildListKey(params)] ?? false;

  String? errorMessageFor(LabTestParams params) =>
      _errorMap[_buildListKey(params)];

  bool hasMoreFor(LabTestParams params) =>
      _hasMoreMap[_buildListKey(params)] ?? true;

  final Map<int, LabTestModel> _labTestDetailsMap = {};
  final Map<int, bool> _isLoadingDetailsMap = {};
  final Map<int, String?> _errorMessageDetailsMap = {};

  LabTestModel? labTestDetailsFor(int id) => _labTestDetailsMap[id];
  bool isLoadingDetailsFor(int id) => _isLoadingDetailsMap[id] ?? false;
  String? errorMessageDetailsFor(int id) => _errorMessageDetailsMap[id];
  bool addIsLoading = false;
  String? addErrorMessage;

  bool deleteIsLoading = false;
  String? deleteErrorMessage;
  Future<void> getLabTests(
    String locale,
    String? token,
    LabTestParams params,
  ) async {
    final key = _buildListKey(params);
    _isLoadingMap[key] = true;
    _errorMap[key] = null;
    _labTestsByKey[key] = [];
    _currentPageMap[key] = 1;
    _hasMoreMap[key] = true;
    notifyListeners();

    if (token == null) {
      _errorMap[key] = S().token_missing;
      _isLoadingMap[key] = false;
      notifyListeners();
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      _errorMap[key] = S().no_internet_message;
      _isLoadingMap[key] = false;
      notifyListeners();
      return;
    }

    final result = await labTestService.getLabTests(locale, token, 1, params);

    result.fold(
      (failure) {
        _errorMap[key] = failure.errorMessage;
        if (kDebugMode) {
          print("failed fetch lab tests: ${failure.errorMessage}");
        }
      },
      (response) {
        _labTestsByKey[key] = response.data;
        _currentPageMap[key] = response.currentPage;
        _hasMoreMap[key] = response.currentPage < response.lastPage;
        if (kDebugMode) print("fetch lab tests success");
      },
    );

    _isLoadingMap[key] = false;
    notifyListeners();
  }

  Future<void> loadMoreLabTests(
    String locale,
    String? token,
    LabTestParams params,
  ) async {
    final key = _buildListKey(params);
    if ((_isLoadingMoreMap[key] ?? false) || !hasMoreFor(params)) return;

    _isLoadingMoreMap[key] = true;
    notifyListeners();

    if (token == null) {
      _isLoadingMoreMap[key] = false;
      notifyListeners();
      return;
    }

    final nextPage = (_currentPageMap[key] ?? 1) + 1;
    final result = await labTestService.getLabTests(
      locale,
      token,
      nextPage,
      params,
    );

    result.fold(
      (failure) {
        if (kDebugMode) {
          print("failed load more lab tests: ${failure.errorMessage}");
        }
      },
      (response) {
        _labTestsByKey[key] = [
          ...(_labTestsByKey[key] ?? []),
          ...response.data,
        ];
        _currentPageMap[key] = response.currentPage;
        _hasMoreMap[key] = response.currentPage < response.lastPage;
      },
    );

    _isLoadingMoreMap[key] = false;
    notifyListeners();
  }

  Future<void> getLabTestDetails(String locale, String? token, int id) async {
    _isLoadingDetailsMap[id] = true;
    _errorMessageDetailsMap[id] = null;
    notifyListeners();

    if (token == null) {
      _isLoadingDetailsMap[id] = false;
      _errorMessageDetailsMap[id] = S().token_missing;
      notifyListeners();
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      _isLoadingDetailsMap[id] = false;
      _errorMessageDetailsMap[id] = S().no_internet_message;
      notifyListeners();
      return;
    }

    final result = await labTestService.getLabTestDetails(locale, token, id);

    result.fold(
      (failure) {
        _errorMessageDetailsMap[id] = failure.errorMessage;
        if (kDebugMode) {
          print("failed fetch lab test details: ${failure.errorMessage}");
        }
      },
      (response) {
        _labTestDetailsMap[id] = response.data;
        if (kDebugMode) print("fetch lab test details success for id=$id");
      },
    );

    _isLoadingDetailsMap[id] = false;
    notifyListeners();
  }

  Future<bool> addPatientLabTest(
    AddPatientLabTestParams params,
    String locale,
    String? token,
  ) async {
    addIsLoading = true;
    addErrorMessage = null;
    notifyListeners();

    if (token == null) {
      addErrorMessage = S().token_missing;
      addIsLoading = false;
      notifyListeners();
      return false;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      addErrorMessage = S().no_internet_message;
      addIsLoading = false;
      notifyListeners();
      return false;
    }

    final result = await labTestService.addPatientLabTest(
      locale,
      token,
      params,
    );

    return result.fold(
      (failure) {
        addErrorMessage = failure.errorMessage;
        if (kDebugMode) print("add lab test failed: ${failure.errorMessage}");
        addIsLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("add lab test success");
        addIsLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> deletePatientLabTest(
    int labTestId,
    String locale,
    String? token,
  ) async {
    deleteIsLoading = true;
    deleteErrorMessage = null;
    notifyListeners();

    if (token == null) {
      deleteErrorMessage = S().token_missing;
      deleteIsLoading = false;
      notifyListeners();
      return false;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      deleteErrorMessage = S().no_internet_message;
      deleteIsLoading = false;
      notifyListeners();
      return false;
    }

    final result = await labTestService.deletePatientLabTest(
      locale,
      token,
      labTestId,
    );

    return result.fold(
      (failure) {
        deleteErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("delete lab test failed: ${failure.errorMessage}");
        }
        deleteIsLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("delete lab test success");
        deleteIsLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}
