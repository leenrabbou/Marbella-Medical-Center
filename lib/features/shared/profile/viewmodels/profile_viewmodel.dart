import 'package:flutter/foundation.dart';
import 'package:marbella/features/shared/profile/services/profile_service.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/features/shared/profile/models/user_model.dart';
import 'package:marbella/generated/l10n.dart';

class ProfileViewmodel extends ChangeNotifier {
  ProfileService profileServices;
  final NetworkInfo networkInfo;
  ProfileViewmodel({required this.profileServices, required this.networkInfo});
  bool isLoading = false;
  bool getProfileSuccessfully = false;
  EmployeeModel? profileData;
  String? errorMessage;
  Future<void> getProfile(String locale, String? token) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    if (token == null) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) print("error");
      return;
    }
    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      errorMessage = S().no_internet_message;
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print("Connection failed: No network.");
      }
      return;
    }
    final result = await profileServices.getProfile(locale, token);
    result.fold(
      (failure) {
        errorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("fetch profile failed ${failure.errorMessage}");
        }
      },
      (response) {
        getProfileSuccessfully = true;
        profileData = response.data;
        if (kDebugMode) print("fetch profile success");
      },
    );
    isLoading = false;
    notifyListeners();
  }
}
