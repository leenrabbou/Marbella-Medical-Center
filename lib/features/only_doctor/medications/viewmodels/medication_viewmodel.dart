import 'package:marbella/features/only_doctor/medications/models/medication_model.dart';
import 'package:marbella/features/only_doctor/medications/services/medication_service.dart';
import 'package:flutter/foundation.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/generated/l10n.dart';

class MedicationViewmodel extends ChangeNotifier {
  MedicationService medicationService;
  final NetworkInfo networkInfo;
  MedicationViewmodel({
    required this.medicationService,
    required this.networkInfo,
  });

  bool isLoadingList = false;
  bool getMedicationsSuccessfully = false;
  List<MedicationModel> mediactionsList = [];
  String? getListErrorMessage;

  bool updateisLoading = false;
  String? updateErrorMessage;

  bool addisLoading = false;
  String? addErrorMessage;

  bool deleteisLoading = false;
  String? deleteErrorMessage;

  Future<void> getMedications(String locale, String? token) async {
    isLoadingList = true;
    getListErrorMessage = null;
    mediactionsList = [];
    notifyListeners();

    if (token == null) {
      getListErrorMessage = S().token_missing;
      isLoadingList = false;
      notifyListeners();
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      getListErrorMessage = S().no_internet_message;
      isLoadingList = false;
      notifyListeners();
      return;
    }

    final result = await medicationService.getMedications(locale, token);

    result.fold(
      (failure) {
        getListErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("failed fetch medications: ${failure.errorMessage}");
        }
      },
      (response) {
        getMedicationsSuccessfully = true;
        mediactionsList = response.data;
        if (kDebugMode) print("fetch medications success");
      },
    );

    isLoadingList = false;
    notifyListeners();
  }

  Future<bool> updateMedication(
    UpdateMedicationParams params,
    int medicationId,
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

    final result = await medicationService.updateMedication(
      locale,
      token,
      params,
      medicationId,
    );

    return result.fold(
      (failure) {
        updateErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("update Medication failed: ${failure.errorMessage}");
        }
        updateisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("update Medication success");
        updateisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> addMedication(
    UpdateMedicationParams params,
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

    final result = await medicationService.addMedication(locale, token, params);

    return result.fold(
      (failure) {
        addErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("add Medication failed: ${failure.errorMessage}");
        }
        addisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("add Medication success");
        addisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> deleteMedication(
    int medicationId,
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

    final result = await medicationService.deleteMedication(
      locale,
      token,
      medicationId,
    );

    return result.fold(
      (failure) {
        deleteErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("delete Medication failed: ${failure.errorMessage}");
        }
        deleteisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("delete Medication success");
        deleteisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}
