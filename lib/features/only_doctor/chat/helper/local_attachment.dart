import 'dart:io';

enum AttachmentKind { image, file }

class LocalAttachment {
  final File file;
  final AttachmentKind kind;

  LocalAttachment({required this.file, required this.kind});

  String get name => file.path.split('/').last;
}
