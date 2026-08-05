import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/features/only_doctor/doctor_certificate/models/certificate_model.dart';
import 'package:marbella/features/only_doctor/doctor_certificate/service/certificates_services.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/foundation.dart';

class CertificatesViewmodel extends ChangeNotifier {
  CertificatesServices certificatesServices;
  final NetworkInfo networkInfo;

  CertificatesViewmodel({
    required this.certificatesServices,
    required this.networkInfo,
  });

  bool isLoadingCertificates = false;
  bool isLoadingMore = false;
  String? certificatesErrorMessage;
  List<CertificateModel> certificates = [];
  int _currentPage = 1;
  bool hasMore = true;

  Future<void> getCertificates(String locale, String? token) async {
    isLoadingCertificates = true;
    certificatesErrorMessage = null;
    certificates = [];
    _currentPage = 1;
    hasMore = true;
    notifyListeners();

    if (token == null) {
      certificatesErrorMessage = S().token_missing;
      isLoadingCertificates = false;
      notifyListeners();
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      certificatesErrorMessage = S().no_internet_message;
      isLoadingCertificates = false;
      notifyListeners();
      return;
    }

    final result = await certificatesServices.getCertificates(
      locale,
      token,
      _currentPage,
    );

    result.fold(
      (failure) {
        certificatesErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("failed fetch all Certificates: ${failure.errorMessage}");
        }
      },
      (response) {
        certificates = response.data.data;
        hasMore = response.data.currentPage < response.data.lastPage;
        if (kDebugMode) print("fetch all Certificates success");
      },
    );

    isLoadingCertificates = false;
    notifyListeners();
  }
}
