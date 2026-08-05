import 'package:flutter/foundation.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/appointments/models/appointment_model.dart';
import 'package:marbella/features/only_doctor/appointments/services/appointments_service.dart';
import 'package:marbella/generated/l10n.dart';

class AppointmentsViewmodel extends ChangeNotifier {
  final AppointmentsService appointmentsServices;
  final NetworkInfo networkInfo;

  AppointmentsViewmodel({
    required this.appointmentsServices,
    required this.networkInfo,
  });

  final Map<String, bool> _loadingMap = {};
  final Map<String, String?> _errorMap = {};
  final Map<String, List<AppointmentModel>> _appointmentsByStatus = {};

  bool getListSuccessfully = false;

  bool isLoadingDetails = false;
  String? errorMessageDetails;
  AppointmentModel? appointmentDetails;

  String _getStatusKey(String? status) => status ?? 'all';

  bool get isLoading => _loadingMap.values.any((v) => v == true);

  List<AppointmentModel> get appointmentsList =>
      _appointmentsByStatus[_getStatusKey(null)] ?? [];

  String? get errorMessage => _errorMap[_getStatusKey(null)];

  bool isLoadingByStatus(String? status) =>
      _loadingMap[_getStatusKey(status)] ?? false;

  String? errorByStatus(String? status) => _errorMap[_getStatusKey(status)];

  List<AppointmentModel> getAppointmentsListByStatus(String? status) =>
      _appointmentsByStatus[_getStatusKey(status)] ?? [];

  Future<void> getAppointmentsList(
    String locale,
    String? token,
    AppointmentsParams params,
  ) async {
    final statusKey = _getStatusKey(params.status);

    _loadingMap[statusKey] = true;
    _errorMap[statusKey] = null;
    _appointmentsByStatus[statusKey] = [];
    Future.microtask(notifyListeners);

    if (token == null) {
      _loadingMap[statusKey] = false;
      _errorMap[statusKey] = S().token_missing;
      Future.microtask(notifyListeners);
      if (kDebugMode) print('[Appointments] Error: token is null');
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      _loadingMap[statusKey] = false;
      _errorMap[statusKey] = S().no_internet_message;
      Future.microtask(notifyListeners);
      if (kDebugMode) print('[Appointments] Error: no internet connection');
      return;
    }

    final result = await appointmentsServices.getAppointments(
      locale,
      token,
      params,
    );

    result.fold(
      (failure) {
        _errorMap[statusKey] = failure.errorMessage;
        getListSuccessfully = false;
        if (kDebugMode) {
          print('[${params.status}] Failed: ${failure.errorMessage}');
        }
      },
      (response) {
        _appointmentsByStatus[statusKey] = response.data;
        getListSuccessfully = true;
        if (kDebugMode) {
          print('[${params.status}] Success: ${response.data.length} items');
        }
      },
    );

    _loadingMap[statusKey] = false;
    notifyListeners();
  }

  Future<void> getAppointmentDetails(
    String locale,
    String? token,
    int id,
  ) async {
    isLoadingDetails = true;
    errorMessageDetails = null;
    Future.microtask(notifyListeners);

    if (token == null) {
      isLoadingDetails = false;
      Future.microtask(notifyListeners);
      if (kDebugMode) print('[AppointmentDetails] Error: token is null');
      return;
    }

    final result = await appointmentsServices.getAppointmentDetails(
      locale,
      token,
      id,
    );

    result.fold(
      (failure) {
        errorMessageDetails = failure.errorMessage;
        if (kDebugMode) {
          print('[AppointmentDetails] Failed: ${failure.errorMessage}');
        }
      },
      (response) {
        appointmentDetails = response.data;
        if (kDebugMode) print('[AppointmentDetails] Success');
      },
    );

    isLoadingDetails = false;
    notifyListeners();
  }
}
