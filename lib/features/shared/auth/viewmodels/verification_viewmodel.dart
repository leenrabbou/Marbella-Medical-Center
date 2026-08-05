import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:marbella/features/shared/auth/services/verification_service.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/generated/l10n.dart';

class VerificationViewmodel extends ChangeNotifier {
  final VerificationService verificationRepository;
  final NetworkInfo networkInfo;

  VerificationViewmodel({
    required this.verificationRepository,
    required this.networkInfo,
  });

  bool isLoadingGetCode = false;
  String? errorMessageGetCode;
  bool getCodeSuccessfully = false;

  bool isLoadingVerify = false;
  String? errorMessageVerify;
  bool verifySuccessfully = false;

  Future<void> getVerificationCode(String locale, String? token) async {
    isLoadingGetCode = true;
    errorMessageGetCode = null;
    getCodeSuccessfully = false;
    notifyListeners();
    if (token == null) {
      errorMessageGetCode = S().token_missing;
      isLoadingGetCode = false;
      notifyListeners();
      return;
    }
    final result = await verificationRepository.getVerificationCode(
      locale,
      token,
    );

    result.fold(
      (failure) {
        errorMessageGetCode = failure.errorMessage;
        if (kDebugMode) {
          print("Get Code failed: ${failure.errorMessage}");
        }
      },
      (_) {
        getCodeSuccessfully = true;
        if (kDebugMode) print("Get Code success");
      },
    );

    isLoadingGetCode = false;
    notifyListeners();
  }

  Future<void> verifyPhone(String otp, String locale, String? token) async {
    isLoadingVerify = true;
    errorMessageVerify = null;
    verifySuccessfully = false;
    notifyListeners();
    if (token == null) {
      errorMessageVerify = S().token_missing;
      isLoadingVerify = false;
      notifyListeners();
      return;
    }
    final result = await verificationRepository.verifyPhone(locale, token, otp);

    result.fold(
      (failure) {
        errorMessageVerify = failure.errorMessage;
        if (kDebugMode) {
          print("Verify Phone failed: ${failure.errorMessage}");
        }
      },
      (_) {
        verifySuccessfully = true;
        if (kDebugMode) print("Verify Phone success");
      },
    );

    isLoadingVerify = false;
    notifyListeners();
  }
}
