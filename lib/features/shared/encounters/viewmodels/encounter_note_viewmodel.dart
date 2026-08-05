import 'package:marbella/features/shared/encounters/models/encounter_note_model.dart';
import 'package:marbella/features/shared/encounters/services/encounter_note_service.dart';
import 'package:flutter/foundation.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/connection/network_info.dart';
import 'package:marbella/generated/l10n.dart';

class EncounterNoteViewmodel extends ChangeNotifier {
  EncounterNoteService encounterNotesService;
  final NetworkInfo networkInfo;
  EncounterNoteViewmodel({
    required this.encounterNotesService,
    required this.networkInfo,
  });

  final Map<String, bool> _isLoadingMap = {};
  final Map<String, bool> _getListSuccessfullyMap = {};
  final Map<String, String?> _errorMessageMap = {};
  final Map<String, List<EncounterNoteModel>> _encountersNoteByKey = {};

  bool updateisLoading = false;
  String? updateErrorMessage;

  bool addisLoading = false;
  String? addErrorMessage;

  bool deleteisLoading = false;
  String? deleteErrorMessage;

  String _buildKey(EncounterNoteParams params) {
    return [
      params.patientId?.toString() ?? '-',
      params.encounterId?.toString() ?? '-',
      params.status ?? 'all',
    ].join('|');
  }

  List<EncounterNoteModel> notesFor(EncounterNoteParams params) =>
      _encountersNoteByKey[_buildKey(params)] ?? [];

  bool isLoadingFor(EncounterNoteParams params) =>
      _isLoadingMap[_buildKey(params)] ?? false;

  String? errorMessageFor(EncounterNoteParams params) =>
      _errorMessageMap[_buildKey(params)];

  bool getListSuccessfullyFor(EncounterNoteParams params) =>
      _getListSuccessfullyMap[_buildKey(params)] ?? false;

  Future<void> getEncounterNotes(
    String locale,
    String? token,
    EncounterNoteParams params,
  ) async {
    final key = _buildKey(params);

    _isLoadingMap[key] = true;
    _errorMessageMap[key] = null;
    _encountersNoteByKey[key] = [];
    notifyListeners();

    if (token == null) {
      _errorMessageMap[key] = S().token_missing;
      _isLoadingMap[key] = false;
      notifyListeners();
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      _errorMessageMap[key] = S().no_internet_message;
      _isLoadingMap[key] = false;
      notifyListeners();
      return;
    }

    final result = await encounterNotesService.getEncounterNotes(
      locale,
      token,
      params,
    );

    result.fold(
      (failure) {
        _errorMessageMap[key] = failure.errorMessage;
        if (kDebugMode) {
          print(
            "failed fetch Encounter Notes for $key: ${failure.errorMessage}",
          );
        }
      },
      (response) {
        _getListSuccessfullyMap[key] = true;
        _encountersNoteByKey[key] = response.data;
        if (kDebugMode) print("fetch Encounter Notes success for $key");
      },
    );

    _isLoadingMap[key] = false;
    notifyListeners();
  }

  Future<bool> updateEncounterNote(
    UpdateEncounterNoteParams params,
    int encounterNoteId,
    String locale,
    String? token,
  ) async {
    updateisLoading = true;
    updateErrorMessage = null;
    notifyListeners();
    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) {
      updateErrorMessage = S().no_internet_message;
      updateisLoading = false;
      notifyListeners();
      return false;
    }
    if (token == null) {
      updateErrorMessage = S().token_missing;
      updateisLoading = false;
      notifyListeners();
      return false;
    }

    final result = await encounterNotesService.updateEncounterNote(
      locale,
      token,
      params,
      encounterNoteId,
    );

    return result.fold(
      (failure) {
        updateErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("update Encounter Notes failed: ${failure.errorMessage}");
        }
        updateisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("update Encounter Notes success");
        updateisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> addEncounterNote(
    AddEncounterNoteParams params,
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

    final result = await encounterNotesService.addEncounterNote(
      locale,
      token,
      params,
    );

    return result.fold(
      (failure) {
        addErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("add Encounter Notes failed: ${failure.errorMessage}");
        }
        addisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("add Encounter Notes success");
        addisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> deleteEncounterNote(
    int encounterNoteId,
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

    final result = await encounterNotesService.deleteEncounterNote(
      locale,
      token,
      encounterNoteId,
    );

    return result.fold(
      (failure) {
        deleteErrorMessage = failure.errorMessage;
        if (kDebugMode) {
          print("delete Encounter Notes failed: ${failure.errorMessage}");
        }
        deleteisLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        if (kDebugMode) print("delete Encounter Notes success");
        deleteisLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}
