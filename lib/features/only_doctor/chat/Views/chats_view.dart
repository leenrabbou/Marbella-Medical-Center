import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:flutter/material.dart';
import 'package:marbella/features/only_doctor/chat/Models/conversation_model.dart';
import 'package:marbella/features/only_doctor/chat/viewmodel/chat_viewmodel.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';
import '../Widgets/chat_container_widget.dart';
import 'chat_room_view.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key, this.onChatTap, this.selectedChat});

  final void Function(ConversationModel chat)? onChatTap;

  final ConversationModel? selectedChat;

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  late String locale;
  String? token;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    locale = Localizations.localeOf(context).languageCode;

    token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;
    if (token == null) return;

    await context.read<ChatViewmodel>().getConversations(locale, token);
  }

  Future<void> _handleRefresh() async {
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<ChatViewmodel>();

    final conversations = provider.conversations;
    final isLoading = provider.isLoadingConversations;
    final errorMessage = provider.conversationsErrorMessage;
    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: "Search message...",
          //       hintStyle: TextStyle(color: Colors.grey.shade400),
          //       prefixIcon: const Icon(Icons.search, color: Colors.grey),
          //       filled: true,
          //       fillColor: colorScheme.surface,
          //       contentPadding: const EdgeInsets.symmetric(vertical: 0),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(15),
          //         borderSide: BorderSide.none,
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: LiquidPullToRefresh(
              color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
              backgroundColor: colorScheme.surface,
              height: 50,
              onRefresh: _handleRefresh,
              child: Center(
                child: StateWidget(
                  isLoading: isLoading && conversations.isEmpty,
                  error: errorMessage,
                  isEmpty:
                      !isLoading &&
                      errorMessage == null &&
                      conversations.isEmpty,
                  onRetry: _handleRefresh,
                  noDataMsg: S().no_data,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final chat = conversations[index];
                      final isSelected =
                          widget.selectedChat != null &&
                          widget.selectedChat!.patient.givenName ==
                              chat.patient.givenName;

                      return ChatContainerWidget(
                        chat: chat,
                        isSelected: isSelected,
                        onTap: () {
                          if (widget.onChatTap != null) {
                            widget.onChatTap!(chat);
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
