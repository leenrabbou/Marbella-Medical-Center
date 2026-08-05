import 'package:marbella/features/only_doctor/lab_tests/models/medical_test_model.dart';
import 'package:marbella/features/only_doctor/lab_tests/services/medical_test_service.dart';
import 'package:flutter/foundation.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/generated/l10n.dart';

class MedicalTestViewmodel extends ChangeNotifier {
  MedicalTestService medicalTestService;
  final NetworkInfo networkInfo;
  MedicalTestViewmodel({
    required this.medicalTestService,
    required this.networkInfo,
  });

  bool isLoadingList = false;
  String? getListErrorMessage;
  List<MedicalTestModel> medicalTestsList = [];

  Future<void> getMedicalTests(String locale, String? token) async {
    isLoadingList = true;
    getListErrorMessage = null;
    medicalTestsList = [];
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

    final result = await medicalTestService.getMedicalTests(locale, token);

    result.fold(
      (failure) {
        getListErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("failed fetch medical tests: ${failure.errorMessage}");
        }
      },
      (response) {
        medicalTestsList = response.data;
        if (kDebugMode) print("fetch medical tests success");
      },
    );

    isLoadingList = false;
    notifyListeners();
  }
}
