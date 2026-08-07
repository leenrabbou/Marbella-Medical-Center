import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:marbella/features/shared/auth/services/auth_service.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/auth/models/auth_response_model.dart';

class AuthViewmodel extends ChangeNotifier {
  final AuthService authRepository;
  final NetworkInfo networkInfo;

  AuthViewmodel({required this.authRepository, required this.networkInfo});

  bool isLoadingLogIn = false;
  bool isVerified = false;
  AuthResponseModel? response;
  AuthResponseModel? userFromCache;
  String? errorMessageLogIn;

  bool isLoadingLogOut = false;
  String? errorMessageLogOut;

  bool logoutSuccessfully = false;
  final ValueNotifier<int> rateLimitSecondsNotifier = ValueNotifier<int>(0);
  int get rateLimitSeconds => rateLimitSecondsNotifier.value;

  bool isPermanentlyLocked = false;
  Timer? _rateLimitTimer;

  bool get isLoggedIn => response != null || userFromCache != null;
  AuthResponseModel? get activeUserResponse => response ?? userFromCache;
  String? get activeUserToken => activeUserResponse?.data?.token;
  bool isLoadingChangePassword = false;
  String? errorMessageChangePassword;
  bool changePasswordSuccessfully = false;

  void _startRateLimitTimer() {
    _rateLimitTimer?.cancel();
    if (rateLimitSecondsNotifier.value <= 0) return;

    _rateLimitTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      rateLimitSecondsNotifier.value--;
      if (rateLimitSecondsNotifier.value <= 0) {
        timer.cancel();
        notifyListeners();
      }
    });
  }

  int _extractSeconds(String message) {
    final regex = RegExp(r'(\d+)\s*seconds');
    final match = regex.firstMatch(message);
    if (match != null) return int.parse(match.group(1)!);
    return 0;
  }

  int _convertDurationToSeconds(String message) {
    final regex = RegExp(r'(\d+)\s*(minutes?|seconds?|hours?)');
    final match = regex.firstMatch(message);
    if (match != null) {
      final number = int.parse(match.group(1)!);
      final unit = match.group(2)!;
      if (unit.contains('hour')) return number * 3600;
      if (unit.contains('minute')) return number * 60;
      return number;
    }
    return 0;
  }

  Future<void> login(LoginParams params, String locale) async {
    isLoadingLogIn = true;
    errorMessageLogIn = null;
    response = null;
    isPermanentlyLocked = false;
    rateLimitSecondsNotifier.value = 0;
    notifyListeners();

    final result = await authRepository.logIn(params, locale);

    result.fold(
      (failure) {
        final msg = failure.errorMessage;
        errorMessageLogIn = msg;
        if (failure.status == 429) {
          final seconds = _extractSeconds(msg);
          rateLimitSecondsNotifier.value = seconds;
          _startRateLimitTimer();
          notifyListeners();
          return;
        }

        if (failure.status == 423) {
          final seconds = _convertDurationToSeconds(msg);
          if (seconds > 0) {
            rateLimitSecondsNotifier.value = seconds;
            _startRateLimitTimer();
            isPermanentlyLocked = false;
          } else {
            isPermanentlyLocked = true;
          }
          notifyListeners();
          return;
        }
        notifyListeners();
      },
      (loginResponse) {
        if (loginResponse.data == null) {
          errorMessageLogIn = loginResponse.message;
          return;
        }

        response = loginResponse;
        isVerified = loginResponse.data!.phoneNumberVerifiedAt != null;
      },
    );

    isLoadingLogIn = false;
    notifyListeners();
  }

  Future<void> loadUser() async {
    errorMessageLogIn = null;
    final result = await authRepository.loadCachedUser();

    result.fold(
      (failure) {
        userFromCache = null;
        isVerified = false;
        if (kDebugMode) {
          print("Load cached user failed: ${failure.errorMessage}");
        }
      },
      (userModel) {
        userFromCache = AuthResponseModel(
          status: 1,
          message: 'Loaded from cache',
          data: userModel,
        );
        isVerified = userModel.phoneNumberVerifiedAt != null;
        if (kDebugMode) print("Cached user loaded: ${userModel.toJson()}");
      },
    );

    notifyListeners();
  }

  Future<void> logout(String locale) async {
    isLoadingLogOut = true;
    errorMessageLogOut = null;
    logoutSuccessfully = false;
    notifyListeners();

    if (activeUserToken == null) {
      await authRepository.clearLocalSession();
      _clearLocalState();
      logoutSuccessfully = true;
      isLoadingLogOut = false;
      notifyListeners();
      if (kDebugMode) print("Logout success (no session).");
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      errorMessageLogOut = S().no_internet_message;
      isLoadingLogOut = false;
      notifyListeners();
      return;
    }

    final result = await authRepository.logOut(locale, activeUserToken!);
    result.fold(
      (failure) {
        errorMessageLogOut = failure.errorMessage;
        _clearLocalState();
        logoutSuccessfully = true;
        if (kDebugMode) {
          print(
            "Logout API failed but local state cleared: ${failure.errorMessage}",
          );
        }
      },
      (_) {
        _clearLocalState();
        logoutSuccessfully = true;
        if (kDebugMode) print("Logout success, local state cleared.");
      },
    );

    isLoadingLogOut = false;
    notifyListeners();
  }

  Future<void> forceLogout() async {
    await authRepository.clearLocalSession();
    _clearLocalState();
    logoutSuccessfully = true;
    errorMessageLogOut = null;
    notifyListeners();
  }

  void _clearLocalState() {
    response = null;
    userFromCache = null;
    isVerified = false;
    rateLimitSecondsNotifier.value = 0;
    isPermanentlyLocked = false;
    _rateLimitTimer?.cancel();
  }

  void markUserAsVerified() {
    isVerified = true;
    final target = activeUserResponse?.data;
    if (target == null) return;

    final updated = target.copyWith(
      phoneNumberVerifiedAt: DateTime.now().toString(),
    );

    if (userFromCache != null) {
      userFromCache = AuthResponseModel(
        status: userFromCache!.status,
        message: userFromCache!.message,
        data: updated,
      );
    }
    if (response != null) {
      response = AuthResponseModel(
        status: response!.status,
        message: response!.message,
        data: updated,
      );
    }

    authRepository.updateUserData(updated);
    notifyListeners();
  }

  @override
  void dispose() {
    _rateLimitTimer?.cancel();
    rateLimitSecondsNotifier.dispose();
    super.dispose();
  }
}
