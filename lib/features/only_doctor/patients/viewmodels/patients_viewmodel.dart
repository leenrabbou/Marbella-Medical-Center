import 'package:flutter/foundation.dart';
import 'package:marbella/features/only_doctor/patients/services/patients_service.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/patients/models/patient_model.dart';
import 'package:marbella/generated/l10n.dart';

class PatientsViewmodel extends ChangeNotifier {
  PatientsService patientsServices;
  final NetworkInfo networkInfo;
  PatientsViewmodel({
    required this.patientsServices,
    required this.networkInfo,
  });

  List<PatientModel> allPatients = [];
  String? errorMessage;

  int currentPage = 1;
  bool _hasMore = true;
  bool isFetching = false;
  bool isLoading = false;

  bool get hasMore => _hasMore;

  bool isLoadingDetails = false;
  String? errorMessageDetails;
  PatientModel? patientDetails;

  final Map<String, Uint8List> _imageCache = {};
  final Set<String> _loadingUrls = {};

  Future<void> getPatients(
    String locale,
    String? token,
    PatientsParams params,
    int pageToFetch,
  ) async {
    if (isFetching || !_hasMore) return;

    isFetching = true;
    if (pageToFetch == 1) {
      isLoading = true;
      allPatients.clear();
    }
    errorMessage = null;
    notifyListeners();

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      errorMessage = S().no_internet_message;
      isLoading = false;
      isFetching = false;
      notifyListeners();
      if (kDebugMode) print('[Patients] No network.');
      return;
    }

    final result = await patientsServices.getPatients(
      locale,
      token,
      pageToFetch,
      params,
    );

    result.fold(
      (failure) {
        errorMessage = failure.errorMessage;
        _hasMore = false;
        if (kDebugMode) print('[Patients] Failed: ${failure.errorMessage}');
      },
      (response) {
        allPatients.addAll(response.data.data);
        currentPage = response.data.currentPage + 1;
        _hasMore = response.data.currentPage < response.data.lastPage;
        if (kDebugMode) {
          print(
            '[Patients] Page ${response.data.currentPage} loaded. '
            'Next: $currentPage',
          );
        }
      },
    );

    isFetching = false;
    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshToFetchDataList(
    String locale,
    String? token,
    PatientsParams params,
  ) async {
    currentPage = 1;
    _hasMore = true;
    isFetching = false;
    isLoading = false;
    errorMessage = null;
    notifyListeners();
    await getPatients(locale, token, params, 1);
  }

  Future<void> getPatientDetails(String locale, String? token, int id) async {
    isLoadingDetails = true;
    errorMessageDetails = null;
    notifyListeners();
    if (token == null) {
      isLoadingDetails = false;
      notifyListeners();
      return;
    }
    final result = await patientsServices.getPatientDetails(locale, token, id);
    result.fold(
      (failure) {
        errorMessageDetails = failure.errorMessage;
        if (kDebugMode) {
          print('[Patient Details] Failed: ${failure.errorMessage}');
        }
      },
      (response) {
        patientDetails = response.data;
        if (kDebugMode) print('[Patient Details] Success');
      },
    );
    isLoadingDetails = false;
    notifyListeners();
  }

  Future<Uint8List?> getPatientImage(
    String locale,
    String? token,
    String url,
  ) async {
    if (_imageCache.containsKey(url)) return _imageCache[url];
    if (_loadingUrls.contains(url)) return null;
    if (token == null || url.isEmpty) return null;
    _loadingUrls.add(url);
    try {
      final response = await patientsServices.getFile(locale, token, url);
      return response.fold(
        (failure) {
          if (kDebugMode) print('[Image] Failed $url: ${failure.errorMessage}');
          return null;
        },
        (bytes) {
          if (bytes.isNotEmpty) {
            _imageCache[url] = bytes;
            if (kDebugMode) print('[Image] Cached $url');
            return bytes;
          }
          return null;
        },
      );
    } catch (e) {
      if (kDebugMode) print('[Image] Exception $url: $e');
      return null;
    } finally {
      _loadingUrls.remove(url);
    }
  }
}
