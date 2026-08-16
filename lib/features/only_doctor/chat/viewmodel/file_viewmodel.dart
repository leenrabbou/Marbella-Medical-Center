import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gal/gal.dart';
import 'package:marbella/features/only_doctor/chat/service/file_service.dart';

class FileViewmodel extends ChangeNotifier {
  final FileService downloadService;

  FileViewmodel({required this.downloadService});

  bool isLoading = false;
  String? errorMessage;
  Uint8List? fileBytes;

  Future<void> getFile(String locale, String? token, String url) async {
    isLoading = true;
    errorMessage = null;
    fileBytes = null;
    notifyListeners();

    if (token == null || url.isEmpty) {
      errorMessage = "Authentication token or file URL is missing.";
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await downloadService.getFile(locale, token, url);
      response.fold(
        (failure) {
          errorMessage = failure.errorMessage;
          fileBytes = null;
        },
        (bytes) {
          if (bytes.isNotEmpty) {
            fileBytes = bytes;
          } else {
            errorMessage = "Empty File bytes received";
          }
        },
      );
    } catch (e) {
      fileBytes = null;
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> saveFileBytes(
    Uint8List bytes,
    String fileName, {
    required bool isImage,
  }) async {
    if (bytes.isEmpty) return false;

    try {
      if (isImage) {
        final hasAccess = await Gal.hasAccess();
        if (!hasAccess) {
          final granted = await Gal.requestAccess();
          if (!granted) {
            errorMessage = "permission_denied";
            notifyListeners();
            return false;
          }
        }
        await Gal.putImageBytes(bytes, name: fileName);
        return true;
      } else {
        final savedPath = await FilePicker.saveFile(
          fileName: fileName,
          bytes: bytes,
        );
        return savedPath != null;
      }
    } catch (e) {
      if (kDebugMode) print("Error saving file: $e");
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void reset() {
    fileBytes = null;
    errorMessage = null;
    notifyListeners();
  }
}
