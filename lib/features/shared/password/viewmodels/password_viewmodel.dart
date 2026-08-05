import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:marbella/features/shared/password/services/password_service.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/generated/l10n.dart';

class PasswordViewmodel extends ChangeNotifier {
  final PasswordService passwordRepository;
  final NetworkInfo networkInfo;

  PasswordViewmodel({
    required this.passwordRepository,
    required this.networkInfo,
  });

  bool isLoadingChangePassword = false;
  String? errorMessageChangePassword;
  bool changePasswordSuccessfully = false;

  bool isLoadingForgetPassword = false;
  String? errorMessageForgetPassword;
  bool forgetPasswordSuccessfully = false;

  bool isLoadingCheckOtp = false;
  String? errorMessageCheckOtp;
  bool checkOtpSuccessfully = false;

  bool isLoadingResetPassword = false;
  String? errorMessageResetPassword;
  bool resetPasswordSuccessfully = false;

  Future<void> changePassword(
    ChangePasswordParams params,
    String locale,
    String? token,
  ) async {
    isLoadingChangePassword = true;
    errorMessageChangePassword = null;
    changePasswordSuccessfully = false;
    notifyListeners();
    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      errorMessageChangePassword = S().no_internet_message;
      isLoadingChangePassword = false;
      notifyListeners();
      return;
    }
    if (token == null) {
      isLoadingChangePassword = false;
      notifyListeners();
      if (kDebugMode) print("error");
      return;
    }
    final result = await passwordRepository.changePassword(
      locale,
      token,
      params,
    );

    result.fold(
      (failure) {
        errorMessageChangePassword = failure.errorMessage;
        if (kDebugMode) {
          print("Change Password failed: ${failure.errorMessage}");
        }
      },
      (_) {
        changePasswordSuccessfully = true;
        if (kDebugMode) print("Change Password success");
      },
    );

    isLoadingChangePassword = false;
    notifyListeners();
  }

  Future<void> forgetPassword(String phoneNumber, String locale) async {
    isLoadingForgetPassword = true;
    errorMessageForgetPassword = null;
    forgetPasswordSuccessfully = false;
    notifyListeners();
    final result = await passwordRepository.forgetPassword(locale, phoneNumber);

    result.fold(
      (failure) {
        errorMessageForgetPassword = failure.errorMessage;
        if (kDebugMode) {
          print("Forget Password failed: ${failure.errorMessage}");
        }
      },
      (_) {
        forgetPasswordSuccessfully = true;
        if (kDebugMode) print("Forget Password success");
      },
    );

    isLoadingForgetPassword = false;
    notifyListeners();
  }

  Future<void> checkOtp(CheckOtpParams params, String locale) async {
    isLoadingCheckOtp = true;
    errorMessageCheckOtp = null;
    checkOtpSuccessfully = false;
    notifyListeners();
    final result = await passwordRepository.checkOtp(locale, params);

    result.fold(
      (failure) {
        errorMessageCheckOtp = failure.errorMessage;
        if (kDebugMode) {
          print("Check Otp failed: ${failure.errorMessage}");
        }
      },
      (_) {
        checkOtpSuccessfully = true;
        if (kDebugMode) print("Check Otp success");
      },
    );

    isLoadingCheckOtp = false;
    notifyListeners();
  }

  Future<void> resetPassword(ResetPasswordParams params, String locale) async {
    isLoadingResetPassword = true;
    errorMessageResetPassword = null;
    resetPasswordSuccessfully = false;
    notifyListeners();
    final result = await passwordRepository.resetPassword(locale, params);

    result.fold(
      (failure) {
        errorMessageResetPassword = failure.errorMessage;
        if (kDebugMode) {
          print("Reset Password failed: ${failure.errorMessage}");
        }
      },
      (_) {
        resetPasswordSuccessfully = true;
        if (kDebugMode) print("Reset Password success");
      },
    );

    isLoadingResetPassword = false;
    notifyListeners();
  }
}
