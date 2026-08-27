import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/features/only_doctor/chat/Models/message_model.dart';
import 'package:marbella/features/only_doctor/chat/viewmodel/file_viewmodel.dart';
import 'package:marbella/features/only_doctor/doctor_certificate/widgets/cirtificates_dialogs.dart';
import 'package:marbella/features/only_doctor/doctor_certificate/widgets/pdf_viewer_screen.dart';
import 'package:marbella/features/only_doctor/patients/models/image_model.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class ChatBubbleWidget extends StatelessWidget {
  const ChatBubbleWidget({super.key, required this.message});

  final MessageModel message;

  bool get _isMe => message.isSender == 1;
  bool get _hasAttachments => message.attachments.isNotEmpty;
  bool get _hasCaption =>
      message.body.trim().isNotEmpty && message.body.trim() != 'صورة';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bubbleRadius = 18.r;
    final timeLabel = Constant.bubbleTime(message.sentAt);

    final textMaxWidth = _hasAttachments ? 300.w : 300.w;

    return Align(
      alignment: _isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Semantics(
        label:
            '${_isMe ? "رسالة مرسلة" : "رسالة مستلمة"}, '
            '${_hasAttachments ? "مرفق ${message.attachments.length} ملف, " : ""}'
            '${_hasCaption ? message.body : ""}, $timeLabel',
        child: GestureDetector(
          child: Container(
            constraints: BoxConstraints(maxWidth: textMaxWidth),
            margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: _isMe
                  ? colorScheme.primary.withAlpha(80)
                  : colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(bubbleRadius),
                topRight: Radius.circular(bubbleRadius),
                bottomLeft: _isMe ? Radius.circular(bubbleRadius) : Radius.zero,
                bottomRight: _isMe
                    ? Radius.zero
                    : Radius.circular(bubbleRadius),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_hasAttachments)
                  _buildAttachments(
                    context: context,
                    width: textMaxWidth,
                    timeLabel: timeLabel,
                    colorScheme: colorScheme,
                  ),
                if (_hasCaption || !_hasAttachments)
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 6.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (message.body != 'صورة') ...[
                          Text(
                            message.body,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _isMe
                                  ? colorScheme.onSurfaceVariant
                                  : colorScheme.onSurfaceVariant,
                              height: 1.3,
                            ),
                          ),
                        ],
                        SizedBox(height: 4.h),
                        _buildMetaRow(colorScheme, timeLabel, overlay: false),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachments({
    required BuildContext context,
    required double width,
    required String timeLabel,
    required ColorScheme colorScheme,
  }) {
    final attachments = message.attachments;
    final showOverlayMeta = !_hasCaption;

    Widget imagesWidget = attachments.length == 1
        ? _singleImage(context, attachments.first, width)
        : _imageGrid(context, attachments, width);

    imagesWidget = GestureDetector(
      onLongPress: attachments.length > 1
          ? () => _showDownloadAllSheet(context, attachments)
          : null,
      child: imagesWidget,
    );

    if (!showOverlayMeta) return imagesWidget;

    return Stack(
      children: [
        imagesWidget,
        Positioned(
          right: 8.w,
          bottom: 8.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withAlpha((0.5 * 255).toInt()),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: _buildMetaRow(colorScheme, timeLabel, overlay: true),
          ),
        ),
      ],
    );
  }

  Widget _singleImage(BuildContext context, ImageModel file, double width) {
    final bool isImage = file.mimeType.startsWith('image/');
    return SizedBox(
      width: isImage ? width : 150.w,
      height: isImage ? width * 0.75 : 100.h,
      child: _networkImage(context, file),
    );
  }

  Widget _imageGrid(
    BuildContext context,
    List<ImageModel> attachments,
    double width,
  ) {
    final height = width * 0.75;
    if (attachments.length == 2) {
      return SizedBox(
        width: width,
        height: height,
        child: Row(
          children: [
            Expanded(child: _networkImage(context, attachments[0])),
            SizedBox(width: 1.5.w),
            Expanded(child: _networkImage(context, attachments[1])),
          ],
        ),
      );
    }

    final extraCount = attachments.length - 3;
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        children: [
          Expanded(flex: 2, child: _networkImage(context, attachments[0])),
          SizedBox(width: 1.5.w),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _networkImage(context, attachments[1])),
                SizedBox(height: 1.5.h),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _networkImage(context, attachments[2]),
                      if (extraCount > 0)
                        Container(
                          color: Colors.black.withAlpha((0.45 * 255).toInt()),
                          alignment: Alignment.center,
                          child: Text(
                            '+$extraCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _networkImage(BuildContext context, ImageModel file) {
    final bool isImage = file.mimeType.startsWith('image/');
    return GestureDetector(
      onTap: () {
        isImage
            ? CirtificatesDialogs().showImageDialog(context, file.url)
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PdfViewerScreen(url: file.url, title: file.originalName),
                ),
              );
      },
      onLongPress: () => _showDownloadSheet(context, [file]),
      child: isImage
          ? Image.network(
              file.url,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: SpinKitThreeBounce(color: Colors.white, size: 10.r),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Colors.grey.shade500,
                ),
              ),
            )
          : Container(
              color: Theme.of(context).colorScheme.surface.withAlpha(160),
              alignment: Alignment.center,
              child: const Icon(Icons.picture_as_pdf, color: Colors.red),
            ),
    );
  }

  Widget _buildMetaRow(
    ColorScheme colorScheme,
    String timeLabel, {
    required bool overlay,
  }) {
    final timeColor = overlay
        ? colorScheme.surface
        : (_isMe
              ? colorScheme.onSurfaceVariant.withAlpha((0.7 * 255).toInt())
              : colorScheme.onSurfaceVariant.withAlpha((0.4 * 255).toInt()));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(timeLabel, style: TextStyle(color: timeColor, fontSize: 10.5)),
        if (_isMe) ...[
          SizedBox(width: 10.w),
          Constant.buildStatusIcon(colorScheme: colorScheme, message: message),
        ],
      ],
    );
  }
}

class DateHeaderWidget extends StatelessWidget {
  const DateHeaderWidget({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withAlpha((0.06 * 255).toInt()),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

void _showDownloadSheet(BuildContext context, List<ImageModel> files) {
  showModalBottomSheet(
    context: context,
    builder: (_) => SafeArea(
      child: ListTile(
        leading: const Icon(Icons.download),
        title: Text(S().download),
        onTap: () async {
          Navigator.pop(context);
          await _downloadFiles(context, files);
        },
      ),
    ),
  );
}

void _showDownloadAllSheet(BuildContext context, List<ImageModel> files) {
  showModalBottomSheet(
    context: context,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.download),
            title: Text(S().download_all),
            onTap: () async {
              Navigator.pop(context);
              await _downloadFiles(context, files);
            },
          ),
        ],
      ),
    ),
  );
}

Future<void> _downloadFiles(
  BuildContext context,
  List<ImageModel> files,
) async {
  final fileViewmodel = context.read<FileViewmodel>();
  final locale = Localizations.localeOf(context).languageCode;
  final token =
      context.read<AuthViewmodel>().response?.data?.token ??
      context.read<AuthViewmodel>().userFromCache?.data?.token;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(
      child: SpinKitThreeBounce(
        color: Theme.of(context).primaryColor,
        size: 10.r,
      ),
    ),
  );

  final List<({ImageModel file, Uint8List bytes})> downloaded = [];

  for (final file in files) {
    await fileViewmodel.getFile(locale, token, file.url);
    if (fileViewmodel.errorMessage == null && fileViewmodel.fileBytes != null) {
      downloaded.add((file: file, bytes: fileViewmodel.fileBytes!));
    }
    fileViewmodel.reset();
  }

  if (context.mounted) Navigator.pop(context);

  int successCount = 0;
  for (final item in downloaded) {
    final isImage = item.file.mimeType.startsWith('image/');
    final saved = await fileViewmodel.saveFileBytes(
      item.bytes,
      item.file.originalName,
      isImage: isImage,
    );
    if (saved) successCount++;
  }

  if (context.mounted) {
    final message = successCount == files.length
        ? S().file_saved_successfully
        : successCount == 0
        ? S().save_cancelled
        : S().files_saved_partial(successCount, files.length);

    AppSnackbar.show(
      context,
      message: message,
      type: successCount > 0 ? SnackbarType.success : SnackbarType.error,
    );
  }
}
