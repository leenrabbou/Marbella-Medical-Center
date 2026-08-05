class MessageInfoModel {
  final String message;
  final bool isMe;
  final String status;
  final DateTime time;

  MessageInfoModel({
    required this.message,
    required this.isMe,
    required this.status,
    required this.time,
  });
}
