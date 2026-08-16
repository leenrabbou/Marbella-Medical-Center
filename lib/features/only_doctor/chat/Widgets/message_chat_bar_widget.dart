import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/features/only_doctor/chat/helper/local_attachment.dart';

class MessageChatBarWidget extends StatefulWidget {
  const MessageChatBarWidget({super.key, required this.onSend});

  final void Function(String text, List<File> attachments) onSend;

  @override
  State<MessageChatBarWidget> createState() => _MessageChatBarWidgetState();
}

class _MessageChatBarWidgetState extends State<MessageChatBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<LocalAttachment> _attachments = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int kMaxAttachmentBytes = 5 * 1024 * 1024;

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final picked = await _imagePicker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (picked == null) return;
    final file = File(picked.path);
    if (await file.length() > kMaxAttachmentBytes) {
      _showTooLargeError();
      return;
    }
    setState(
      () => _attachments.add(
        LocalAttachment(file: file, kind: AttachmentKind.image),
      ),
    );
  }

  Future<void> _pickFile() async {
    Navigator.pop(context);
    final result = await FilePicker.pickFiles(allowMultiple: true);
    if (result == null) return;
    for (final path in result.paths.whereType<String>()) {
      final file = File(path);
      if (await file.length() > kMaxAttachmentBytes) {
        _showTooLargeError(fileName: file.path.split('/').last);
        continue;
      }
      setState(
        () => _attachments.add(
          LocalAttachment(file: file, kind: AttachmentKind.file),
        ),
      );
    }
  }

  void _showTooLargeError({String? fileName}) {
    AppSnackbar.show(
      context,
      message: fileName != null
          ? 'الملف "$fileName" أكبر من 5 ميغابايت'
          : 'حجم الملف أكبر من الحد المسموح (5 ميغابايت)',

      type: SnackbarType.info,
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('كاميرا'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_outlined),
              title: const Text('من المعرض'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file_outlined),
              title: const Text('ملف'),
              onTap: _pickFile,
            ),
          ],
        ),
      ),
    );
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty && _attachments.isEmpty) return;

    widget.onSend(text, _attachments.map((a) => a.file).toList());

    _controller.clear();
    setState(() => _attachments.clear());
  }

  bool get _canSend =>
      _controller.text.trim().isNotEmpty || _attachments.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.onSurface.withAlpha((0.06 * 255).toInt()),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_attachments.isNotEmpty)
              SizedBox(
                height: 64.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _attachments.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final a = _attachments[index];
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 56.w,
                          height: 56.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: colorScheme.surfaceContainerHighest,
                            image: a.kind == AttachmentKind.image
                                ? DecorationImage(
                                    image: FileImage(a.file),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: a.kind == AttachmentKind.file
                              ? Icon(
                                  Icons.insert_drive_file,
                                  color: colorScheme.onSurfaceVariant,
                                )
                              : null,
                        ),
                        Positioned(
                          top: -6,
                          right: -6,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _attachments.removeAt(index)),
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            Row(
              children: [
                IconButton(
                  onPressed: _showAttachmentOptions,
                  icon: Icon(Icons.attach_file, color: colorScheme.primary),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالة...',
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: _canSend
                      ? colorScheme.primary
                      : colorScheme.onSurface.withAlpha((0.2 * 255).toInt()),
                  child: IconButton(
                    onPressed: _canSend ? _handleSend : null,
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
