import 'package:flutter/foundation.dart';
import 'package:marbella/features/shared/schedule/services/schedule_service.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/features/shared/schedule/models/schedule_model.dart';
import 'package:marbella/generated/l10n.dart';

class ScheduleViewmodel extends ChangeNotifier {
  ScheduleService scheduleServices;
  final NetworkInfo networkInfo;
  ScheduleViewmodel({
    required this.scheduleServices,
    required this.networkInfo,
  });
  bool isLoading = false;
  bool getListSuccessfully = false;
  List<ScheduleModel> schedule = [];
  String? errorMessage;
  Future<void> getSchedule(String locale, String? token) async {
    isLoading = true;
    errorMessage = null;
    schedule = [];
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
    final result = await scheduleServices.getSchedule(locale, token);
    result.fold(
      (failure) {
        errorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("failed fetch profile${failure.errorMessage}");
        }
      },
      (response) {
        getListSuccessfully = true;
        schedule.addAll(response.data);
        if (kDebugMode) print("fetch schedule success");
      },
    );
    isLoading = false;
    notifyListeners();
  }
}
