import 'dart:io';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/app_avatar.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/features/only_doctor/chat/Models/conversation_model.dart';
import 'package:marbella/features/only_doctor/chat/Widgets/chat_bubble_widget.dart';
import 'package:marbella/features/only_doctor/chat/Widgets/message_chat_bar_widget.dart';
import 'package:marbella/features/only_doctor/chat/viewmodel/chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key, required this.chat, this.showAppBar = true});

  final ConversationModel chat;

  final bool showAppBar;

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  late String locale;
  String? token;
  final ScrollController _scrollController = ScrollController();

  late ChatViewmodel _chatViewmodel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatViewmodel = context.read<ChatViewmodel>();
      _chatViewmodel.setActiveConversation(widget.chat.id);
      _fetchData();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _chatViewmodel.setActiveConversation(null);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    locale = Localizations.localeOf(context).languageCode;
    token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;
    if (token == null) return;

    await context.read<ChatViewmodel>().getMessages(
      locale,
      token,
      widget.chat.id,
    );

    if (context.mounted) {
      context.read<ChatViewmodel>().markConversationAsRead(widget.chat.id);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    locale = Localizations.localeOf(context).languageCode;
    token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;
    if (token == null) return;

    await context.read<ChatViewmodel>().loadMoreMessages(
      locale,
      token,
      widget.chat.id,
    );
  }

  Future<void> _sendMessage(String text, List<File> attachments) async {
    locale = Localizations.localeOf(context).languageCode;
    token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;
    if (token == null) return;
    if (attachments.length <= 5) {
      await context.read<ChatViewmodel>().sendMessage(
        text,
        attachments,
        locale,
        token,
        widget.chat.id,
      );
    } else {
      AppSnackbar.show(
        context,
        message: 'مسموح 5 ملفات كحد أقصى.',
        type: SnackbarType.info,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatViewmodel>();
    final conversations = provider.messages;
    Color avatarColor =
        Constant.listColors[widget.chat.patient.givenName.length %
            Constant.listColors.length];
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: colorScheme.surface,
              toolbarHeight: 40.h,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, size: 15),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              title: _buildAppBarTitle(avatarColor),
            )
          : null,
      body: Column(
        children: [
          if (!widget.showAppBar) _buildTabletHeader(context, avatarColor),

          Expanded(
            child: Semantics(
              liveRegion: true,
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                itemCount:
                    conversations.length +
                    (provider.isLoadingMoreMessages ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == conversations.length) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: SpinKitThreeBounce(
                          color: Theme.of(context).primaryColor,
                          size: 15.r,
                        ),
                      ),
                    );
                  }
                  final msg = conversations[index];
                  return ChatBubbleWidget(message: msg);
                },
              ),
            ),
          ),
          MessageChatBarWidget(
            onSend: (text, attachments) => _sendMessage(text, attachments),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle(Color avatarColor) {
    return Row(
      children: [
        AppAvatar(
          size: 40.r,
          imageUrl: widget.chat.patient.image?.url,
          initials:
              widget.chat.patient.givenName.substring(0, 1) +
              widget.chat.patient.familyName.substring(0, 1),
          color:
              Constant.listColors[(widget.chat.patient.givenName +
                          widget.chat.patient.familyName)
                      .length %
                  Constant.listColors.length],
        ),
        const SizedBox(width: 10),
        Text(
          '${widget.chat.patient.givenName} + ${widget.chat.patient.familyName}',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTabletHeader(BuildContext context, Color avatarColor) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.onSurface.withAlpha((0.06 * 255).toInt()),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: avatarColor,
            radius: 20.r,
            child: Text(
              widget.chat.patient.givenName[0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              widget.chat.patient.givenName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
