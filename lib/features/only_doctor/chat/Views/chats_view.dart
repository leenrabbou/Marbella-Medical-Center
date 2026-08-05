import 'package:marbella/features/only_doctor/chat/Models/chat_model.dart';
import 'package:flutter/material.dart';
import '../Widgets/chat_container_widget.dart';
import 'chat_room_view.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({super.key, this.onChatTap, this.selectedChat});

  final void Function(ChatModel chat)? onChatTap;

  final ChatModel? selectedChat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    List<ChatModel> dummyChats = [
      ChatModel(
        name: "Leen Rabbou",
        lastMsg:
            "See you at the office! Don't forget the files we discussed yesterday.",
        status: "seen",
        unreadCount: 125,
        time: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      ChatModel(
        name: "Ali Ahmed",
        lastMsg: "Did you check the new UI designs? I sent them to your email.",
        status: "delivered",
        unreadCount: 0,
        time: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      ChatModel(
        name: "Jordan",
        lastMsg: "Okay, sounds good!",
        status: "seen",
        unreadCount: 0,
        time: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ChatModel(
        name: "Sarah Smith",
        lastMsg: "The project is almost done 🚀 we are launching on Monday!",
        status: "sent",
        unreadCount: 2,
        time: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      ChatModel(
        name: "Mohammed Al-Fares",
        lastMsg:
            "This is a very long message to test how the UI handles overflow text in the subtitle area of the list tile widget.",
        status: "seen",
        unreadCount: 0,
        time: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      ChatModel(
        name: "Omar Khaled",
        lastMsg: "Call me when you're free, it's urgent.",
        status: "seen",
        unreadCount: 0,
        time: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ChatModel(
        name: "Hana Ibrahim",
        lastMsg: "🔥🔥🔥👏",
        status: "delivered",
        unreadCount: 1,
        time: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ChatModel(
        name: "Technical Support",
        lastMsg: "🎤 Voice message (0:45)",
        status: "seen",
        unreadCount: 0,
        time: DateTime.now().subtract(const Duration(days: 3)),
      ),
      ChatModel(
        name: "Design Team",
        lastMsg: "📷 Sent a photo",
        status: "delivered",
        unreadCount: 0,
        time: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ChatModel(
        name: "Karam J",
        lastMsg: "Let's meet at 5 PM.",
        status: "sent",
        unreadCount: 0,
        time: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search message...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: dummyChats.length,
              itemBuilder: (context, index) {
                final chat = dummyChats[index];
                final isSelected =
                    selectedChat != null && selectedChat!.name == chat.name;

                return ChatContainerWidget(
                  chat: chat,
                  isSelected: isSelected,
                  onTap: () {
                    if (onChatTap != null) {
                      onChatTap!(chat);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatRoomView(chat: chat),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
