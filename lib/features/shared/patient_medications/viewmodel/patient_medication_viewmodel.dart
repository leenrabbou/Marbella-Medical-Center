import 'package:marbella/core/errors/conflict_error.dart';
import 'package:marbella/features/only_doctor/medications/models/conflict_interaction.dart';
import 'package:marbella/features/shared/patient_medications/models/patient_medication_model.dart';
import 'package:marbella/features/shared/patient_medications/services/patient_medications_service.dart';
import 'package:flutter/foundation.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/generated/l10n.dart';

class PatientMedicationViewmodel extends ChangeNotifier {
  PatientMedicationsService patientMedicationsService;
  final NetworkInfo networkInfo;
  PatientMedicationViewmodel({
    required this.patientMedicationsService,
    required this.networkInfo,
  });
  final Map<String, bool> _isLoadingMap = {};
  final Map<String, bool> _getListSuccessfullyMap = {};
  final Map<String, String?> _errorMessageMap = {};
  final Map<String, List<PatientMedicationModel>> _medicationsByKey = {};
  bool updateisLoading = false;
  String? updateErrorMessage;
  bool addisLoading = false;
  String? addErrorMessage;
  bool deleteisLoading = false;
  String? deleteErrorMessage;

  final Map<int, bool> _isLoadingDetailsMap = {};
  final Map<int, String?> _errorMessageDetailsMap = {};
  final Map<int, PatientMedicationModel> _patientMedicationDetailsMap = {};

  bool isLoadingDetailsFor(int id) => _isLoadingDetailsMap[id] ?? false;
  String? errorMessageDetailsFor(int id) => _errorMessageDetailsMap[id];
  PatientMedicationModel? patientMedicationDetailsFor(int id) =>
      _patientMedicationDetailsMap[id];

  String _buildKey(PatientMedicationsParams params) {
    return [
      params.patientId?.toString() ?? '-',
      params.doctorId?.toString() ?? '-',
      params.encounterId?.toString() ?? '-',
      params.status ?? 'all',
    ].join('|');
  }

  List<PatientMedicationModel> medicationsFor(
    PatientMedicationsParams params,
  ) => _medicationsByKey[_buildKey(params)] ?? [];
  bool isLoadingFor(PatientMedicationsParams params) =>
      _isLoadingMap[_buildKey(params)] ?? false;
  String? errorMessageFor(PatientMedicationsParams params) =>
      _errorMessageMap[_buildKey(params)];
  bool getListSuccessfullyFor(PatientMedicationsParams params) =>
      _getListSuccessfullyMap[_buildKey(params)] ?? false;
  Future<void> getPatientMedications(
    String locale,
    String? token,
    PatientMedicationsParams params,
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
    final result = await patientMedicationsService.getPatientMedications(
      locale,
      token,
      params,
    );
    result.fold(
      (failure) {
        _errorMessageMap[key] = failure.errorMessage;
        if (kDebugMode) {
          print(
            "failed fetch Patient Medications for $key: ${failure.errorMessage}",
          );
        }
      },
      (response) {
        _getListSuccessfullyMap[key] = true;
        _medicationsByKey[key] = response.data;
        if (kDebugMode) print("fetch Patient Medications success for $key");
      },
    );
    _isLoadingMap[key] = false;
    notifyListeners();
  }

  Future<void> getPatientMedicationDetails(
    String locale,
    String? token,
    int id,
  ) async {
    _isLoadingDetailsMap[id] = true;
    _errorMessageDetailsMap[id] = null;
    notifyListeners();

    if (token == null) {
      _isLoadingDetailsMap[id] = false;
      _errorMessageDetailsMap[id] = S().token_missing;
      notifyListeners();
      return;
    }

    final result = await patientMedicationsService.getPatientMedicationDetails(
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
        _patientMedicationDetailsMap[id] = response.data;
        if (kDebugMode) print('[Encounter Details] Success for id=$id');
      },
    );

    _isLoadingDetailsMap[id] = false;
    notifyListeners();
  }

  Future<bool> updatePatientMedication(
    UpdatePatientMedicationParams params,
    int patientMedicationId,
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
    final result = await patientMedicationsService.updatePatientMedication(
      locale,
      token,
      params,
      patientMedicationId,
    );
    return result.fold(
      (failure) {
        updateErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("update Patient Medications failed: ${failure.errorMessage}");
        }
        updateisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("update Patient Medications success");
        updateisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  List<ConflictInteraction>? medicationConflictInteractions;
  String? conflictMessage;

  Future<bool> addMedication(
    AddPatientMedicationParams params,
    String locale,
    String? token,
  ) async {
    addisLoading = true;
    addErrorMessage = null;
    medicationConflictInteractions = null;
    conflictMessage = null;
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

    final result = await patientMedicationsService.addPatientMedication(
      locale,
      token,
      params,
    );

    return result.fold(
      (failure) {
        if (failure is ConflictError) {
          medicationConflictInteractions = failure.interactions;
          conflictMessage = failure.errorMessage;
          if (kDebugMode) print("Medication conflict detected");
        } else {
          addErrorMessage = failure.errorMessage;
          if (kDebugMode) {
            print("add Patient Medications failed: ${failure.errorMessage}");
          }
        }
        addisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("add Patient Medications success");
        addisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> deleteMedication(
    int patientMedicationId,
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
    final result = await patientMedicationsService.deletePatientMedication(
      locale,
      token,
      patientMedicationId,
    );
    return result.fold(
      (failure) {
        deleteErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("delete Patient Medications failed: ${failure.errorMessage}");
        }
        deleteisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("delete Patient Medications success");
        deleteisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}
