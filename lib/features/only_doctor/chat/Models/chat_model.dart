class ChatModel {
  final String name;
  final String lastMsg;
  final String status;
  final int unreadCount;
  final DateTime time;

  ChatModel({
    required this.name,
    required this.lastMsg,
    required this.status,
    required this.unreadCount,
    required this.time,
  });
}
