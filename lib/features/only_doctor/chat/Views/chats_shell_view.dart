import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/features/only_doctor/chat/Models/conversation_model.dart';
import 'package:marbella/features/only_doctor/chat/Views/chat_room_view.dart';
import 'package:marbella/features/only_doctor/chat/Views/chats_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/features/only_doctor/chat/viewmodel/chat_viewmodel.dart';
import 'package:provider/provider.dart';

class ChatsShellView extends StatefulWidget {
  const ChatsShellView({super.key});

  @override
  State<ChatsShellView> createState() => _ChatsShellViewState();
}

class _ChatsShellViewState extends State<ChatsShellView> {
  ConversationModel? _selectedChat;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = DeviceInfo.isTablet(context);

        if (!isTablet) {
          return const ChatsView();
        }

        final colorScheme = Theme.of(context).colorScheme;

        return Scaffold(
          body: Row(
            children: [
              SizedBox(
                width: 400.w,
                child: ChatsView(
                  selectedChat: _selectedChat,
                  onChatTap: (chat) {
                    setState(() => _selectedChat = chat);
                    context.read<ChatViewmodel>().markConversationAsRead(
                      chat.id,
                    );
                  },
                ),
              ),

              VerticalDivider(
                width: 1,
                thickness: 1,
                color: colorScheme.onSurface.withAlpha((0.06 * 255).toInt()),
              ),

              Expanded(
                child: _selectedChat == null
                    ? _buildEmptyState(context)
                    : ChatRoomView(
                        key: ValueKey(_selectedChat!.patient.givenName),
                        chat: _selectedChat!,
                        showAppBar: false,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha((0.06 * 255).toInt()),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 45,
                color: colorScheme.primary.withAlpha((0.5 * 255).toInt()),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select a conversation',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Choose a chat from the list to start messaging',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withAlpha((0.5 * 255).toInt()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
