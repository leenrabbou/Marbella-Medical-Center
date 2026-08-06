import 'package:flutter/foundation.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/medications/models/condition_interaction_model.dart';
import 'package:marbella/features/only_doctor/medications/models/drug_interaction_model.dart';
import 'package:marbella/features/only_doctor/medications/services/interaction_service.dart';
import 'package:marbella/generated/l10n.dart';

class InteractionViewmodel extends ChangeNotifier {
  final InteractionService interactionService;
  final NetworkInfo networkInfo;

  InteractionViewmodel({
    required this.interactionService,
    required this.networkInfo,
  });

  bool isLoadingList = false;
  bool getMedicationsSuccessfully = false;
  String? getListErrorMessage;

  List<DrugInteractionModel> drugInteractionsList = [];
  List<ConditionInteractionModel> conditionInteractionsList = [];

  bool updateisLoading = false;
  String? updateErrorMessage;

  bool addisLoading = false;
  String? addErrorMessage;

  bool deleteisLoading = false;
  String? deleteErrorMessage;

  Future<void> getInteractions(
    String locale,
    String? token,
    InteractionParams params,
  ) async {
    isLoadingList = true;
    getListErrorMessage = null;
    getMedicationsSuccessfully = false;
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

    if (params.interactableType == 'medication') {
      drugInteractionsList = [];

      final result = await interactionService
          .getInteractions<DrugInteractionModel>(
            locale,
            token,
            DrugInteractionModel.fromJson,
            params,
          );

      result.fold(
        (failure) {
          getListErrorMessage = failure.errorMessage;
          if (kDebugMode) {
            print("failed fetch drug interactions: ${failure.errorMessage}");
          }
        },
        (response) {
          getMedicationsSuccessfully = true;
          drugInteractionsList = response.data;
          if (kDebugMode) print("fetch drug interactions success");
        },
      );
    } else {
      conditionInteractionsList = [];
      final result = await interactionService
          .getInteractions<ConditionInteractionModel>(
            locale,
            token,
            ConditionInteractionModel.fromJson,
            params,
          );

      result.fold(
        (failure) {
          getListErrorMessage = failure.errorMessage;
          if (kDebugMode) {
            print(
              "failed fetch condition interactions: ${failure.errorMessage}",
            );
          }
        },
        (response) {
          getMedicationsSuccessfully = true;
          conditionInteractionsList = response.data;
          if (kDebugMode) print("fetch condition interactions success");
        },
      );
    }

    isLoadingList = false;
    notifyListeners();
  }

  Future<bool> addInteraction(
    AddInteractionParams params,
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

    final result = await interactionService.addInteraction(
      locale,
      token,
      params,
    );

    return result.fold(
      (failure) {
        addErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("add Interaction failed: ${failure.errorMessage}");
        }
        addisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("add Interaction success");
        addisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> deleteInteraction(
    int interactionId,
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

    final result = await interactionService.deleteInteraction(
      locale,
      token,
      interactionId,
    );

    return result.fold(
      (failure) {
        deleteErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("delete Interaction failed: ${failure.errorMessage}");
        }
        deleteisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("delete Interaction success");
        deleteisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}
