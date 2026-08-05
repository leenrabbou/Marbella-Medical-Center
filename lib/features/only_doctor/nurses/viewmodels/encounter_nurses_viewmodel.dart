import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/features/only_doctor/nurses/services/encounter_nurses_services.dart';
import 'package:marbella/features/shared/profile/models/user_model.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/foundation.dart';

class EncounterNursesViewmodel extends ChangeNotifier {
  EncounterNursesServices encounterNursesServices;
  final NetworkInfo networkInfo;

  EncounterNursesViewmodel({
    required this.encounterNursesServices,
    required this.networkInfo,
  });

  bool isLoadingAllNurses = false;
  bool isLoadingMoreAllNurses = false;
  String? allNursesErrorMessage;
  List<EmployeeModel> allNurses = [];
  int _allNursesCurrentPage = 1;
  bool _allNursesHasMore = true;

  bool get allNursesHasMore => _allNursesHasMore;

  bool isLoadingEncounterNurses = false;
  bool isLoadingMoreEncounterNurses = false;
  String? encounterNursesErrorMessage;
  List<EmployeeModel> encounterNurses = [];
  int _encounterNursesCurrentPage = 1;
  bool _encounterNursesHasMore = true;

  bool get encounterNursesHasMore => _encounterNursesHasMore;

  bool addIsLoading = false;
  String? addErrorMessage;

  bool deleteIsLoading = false;
  String? deleteErrorMessage;

  Future<void> getAllNurses(String locale, String? token) async {
    isLoadingAllNurses = true;
    allNursesErrorMessage = null;
    allNurses = [];
    _allNursesCurrentPage = 1;
    _allNursesHasMore = true;
    notifyListeners();

    if (token == null) {
      allNursesErrorMessage = S().token_missing;
      isLoadingAllNurses = false;
      notifyListeners();
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      allNursesErrorMessage = S().no_internet_message;
      isLoadingAllNurses = false;
      notifyListeners();
      return;
    }

    final result = await encounterNursesServices.getAllNurses(
      locale,
      token,
      _allNursesCurrentPage,
    );

    result.fold(
      (failure) {
        allNursesErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("failed fetch all nurses: ${failure.errorMessage}");
        }
      },
      (response) {
        allNurses = response.data.data;
        _allNursesHasMore = response.data.currentPage < response.data.lastPage;
        if (kDebugMode) print("fetch all nurses success");
      },
    );

    isLoadingAllNurses = false;
    notifyListeners();
  }

  Future<void> loadMoreAllNurses(String locale, String? token) async {
    if (isLoadingMoreAllNurses || !_allNursesHasMore) return;

    isLoadingMoreAllNurses = true;
    notifyListeners();

    if (token == null) {
      isLoadingMoreAllNurses = false;
      notifyListeners();
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      isLoadingMoreAllNurses = false;
      notifyListeners();
      return;
    }

    final nextPage = _allNursesCurrentPage + 1;
    final result = await encounterNursesServices.getAllNurses(
      locale,
      token,
      nextPage,
    );

    result.fold(
      (failure) {
        if (kDebugMode) {
          print("failed load more all nurses: ${failure.errorMessage}");
        }
      },
      (response) {
        allNurses = [...allNurses, ...response.data.data];
        _allNursesCurrentPage = nextPage;
        _allNursesHasMore = response.data.currentPage < response.data.lastPage;
        if (kDebugMode) print("load more all nurses success");
      },
    );

    isLoadingMoreAllNurses = false;
    notifyListeners();
  }

  Future<void> getEncounterNurses(
    String locale,
    String? token,
    int encounterId,
  ) async {
    isLoadingEncounterNurses = true;
    encounterNursesErrorMessage = null;
    encounterNurses = [];
    _encounterNursesCurrentPage = 1;
    _encounterNursesHasMore = true;
    notifyListeners();

    if (token == null) {
      encounterNursesErrorMessage = S().token_missing;
      isLoadingEncounterNurses = false;
      notifyListeners();
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      encounterNursesErrorMessage = S().no_internet_message;
      isLoadingEncounterNurses = false;
      notifyListeners();
      return;
    }

    final result = await encounterNursesServices.getEncounterNurses(
      locale,
      token,
      _encounterNursesCurrentPage,
      encounterId,
    );

    result.fold(
      (failure) {
        encounterNursesErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("failed fetch encounter nurses: ${failure.errorMessage}");
        }
      },
      (response) {
        encounterNurses = response.data.data;
        _encounterNursesHasMore =
            response.data.currentPage < response.data.lastPage;
        if (kDebugMode) print("fetch encounter nurses success");
      },
    );

    isLoadingEncounterNurses = false;
    notifyListeners();
  }

  Future<void> loadMoreEncounterNurses(
    String locale,
    String? token,
    int encounterId,
  ) async {
    if (isLoadingMoreEncounterNurses || !_encounterNursesHasMore) return;

    isLoadingMoreEncounterNurses = true;
    notifyListeners();

    if (token == null) {
      isLoadingMoreEncounterNurses = false;
      notifyListeners();
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      isLoadingMoreEncounterNurses = false;
      notifyListeners();
      return;
    }

    final nextPage = _encounterNursesCurrentPage + 1;
    final result = await encounterNursesServices.getEncounterNurses(
      locale,
      token,
      nextPage,
      encounterId,
    );

    result.fold(
      (failure) {
        if (kDebugMode) {
          print("failed load more encounter nurses: ${failure.errorMessage}");
        }
      },
      (response) {
        encounterNurses = [...encounterNurses, ...response.data.data];
        _encounterNursesCurrentPage = nextPage;
        _encounterNursesHasMore =
            response.data.currentPage < response.data.lastPage;
        if (kDebugMode) print("load more encounter nurses success");
      },
    );

    isLoadingMoreEncounterNurses = false;
    notifyListeners();
  }

  Future<bool> addNurseToEncounter(
    String locale,
    String? token,
    int encounterId,
    int employeeId,
  ) async {
    addIsLoading = true;
    addErrorMessage = null;
    notifyListeners();

    if (token == null) {
      addErrorMessage = S().token_missing;
      addIsLoading = false;
      notifyListeners();
      return false;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      addErrorMessage = S().no_internet_message;
      addIsLoading = false;
      notifyListeners();
      return false;
    }

    final result = await encounterNursesServices.addNurseToEncounter(
      locale,
      token,
      encounterId,
      employeeId,
    );

    return result.fold(
      (failure) {
        addErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("add nurse to encounter failed: ${failure.errorMessage}");
        }
        addIsLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("add nurse to encounter success");
        addIsLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> deleteEncounterNurse(
    String locale,
    String? token,
    int encounterId,
    int nurseId,
  ) async {
    deleteIsLoading = true;
    deleteErrorMessage = null;
    notifyListeners();

    if (token == null) {
      deleteErrorMessage = S().token_missing;
      deleteIsLoading = false;
      notifyListeners();
      return false;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      deleteErrorMessage = S().no_internet_message;
      deleteIsLoading = false;
      notifyListeners();
      return false;
    }

    final result = await encounterNursesServices.deleteEncounterNurse(
      locale,
      token,
      encounterId,
      nurseId,
    );

    return result.fold(
      (failure) {
        deleteErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("delete encounter nurse failed: ${failure.errorMessage}");
        }
        deleteIsLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("delete encounter nurse success");
        deleteIsLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}
