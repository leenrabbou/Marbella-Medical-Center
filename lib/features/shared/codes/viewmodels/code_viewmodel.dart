import 'package:flutter/foundation.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/codes/models/code_model.dart';
import 'package:marbella/features/shared/codes/services/code_service.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/generated/l10n.dart';

class CodeViewmodel extends ChangeNotifier {
  CodeService codeService;
  final NetworkInfo networkInfo;
  CodeViewmodel({required this.codeService, required this.networkInfo});

  final Map<String, List<CodeModel>> _codesByCategory = {};

  List<CodeModel> getCodesByCategory(String category) =>
      _codesByCategory[category] ?? [];

  bool isLoading = false;
  String? errorMessage;

  bool isLoadingAdd = false;
  bool addSuccessfully = false;
  String? addErrorMessage;

  Future<void> getCodes(String locale, String? token, CodeParams params) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    if (token == null) {
      errorMessage = S().token_missing;
      isLoading = false;
      notifyListeners();
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

    final result = await codeService.getCodes(locale, token, params);

    result.fold(
      (failure) {
        errorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("failed fetch codes${failure.errorMessage}");
        }
      },
      (response) {
        _codesByCategory[params.category] = response.data;
        if (kDebugMode) {
          print("fetch codes success for category: ${params.category}");
        }
      },
    );

    isLoading = false;
    notifyListeners();
  }

  Future<CodeModel?> addCode(
    AddCodeParams params,
    String locale,
    String? token,
  ) async {
    isLoadingAdd = true;
    addErrorMessage = null;
    addSuccessfully = false;
    notifyListeners();

    if (token == null) {
      addErrorMessage = S().token_missing;
      isLoadingAdd = false;
      notifyListeners();
      return null;
    }

    final result = await codeService.addCode(locale, token, params);

    return result.fold(
      (failure) {
        addErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("Add Code failed: ${failure.errorMessage}");
        }
        isLoadingAdd = false;
        notifyListeners();
        return null;
      },
      (newCode) {
        addSuccessfully = true;
        _codesByCategory[params.category] = [
          ...(_codesByCategory[params.category] ?? []),
          newCode,
        ];

        if (kDebugMode) print("Add Code success");
        isLoadingAdd = false;
        notifyListeners();
        return newCode;
      },
    );
  }
}
