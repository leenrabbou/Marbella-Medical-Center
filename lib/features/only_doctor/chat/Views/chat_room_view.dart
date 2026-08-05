import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/app_avatar.dart';
import 'package:marbella/features/only_doctor/chat/Models/chat_model.dart';
import 'package:marbella/features/only_doctor/chat/Models/message_info_model.dart';
import 'package:marbella/features/only_doctor/chat/Widgets/chat_bubble_widget.dart';
import 'package:marbella/features/only_doctor/chat/Widgets/message_chat_bar_widget.dart';
import 'package:marbella/features/only_doctor/patients/models/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key, required this.chat, this.showAppBar = true});

  final ChatModel chat;

  final bool showAppBar;

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  late List<MessageInfoModel> chatMessages;

  @override
  void initState() {
    super.initState();
    chatMessages = _buildDummyMessages();
  }

  @override
  void didUpdateWidget(covariant ChatRoomView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chat.name != widget.chat.name) {
      setState(() {
        chatMessages = _buildDummyMessages();
      });
    }
  }

  List<MessageInfoModel> _buildDummyMessages() {
    return [
      MessageInfoModel(
        message: "هلا، كيف حالك اليوم؟",
        isMe: false,
        status: "seen",
        time: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      MessageInfoModel(
        message: "أهلاً! أنا بخير، شكراً لسؤالك. كيف يمكنني مساعدتك؟",
        isMe: true,
        status: "seen",
        time: DateTime.now().subtract(const Duration(minutes: 28)),
      ),
      MessageInfoModel(
        message: "هل لديك أي تحديثات بخصوص المشروع الذي نعمل عليه؟",
        isMe: false,
        status: "seen",
        time: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      MessageInfoModel(
        message:
            "نعم، لقد انتهيت من تصميم واجهة المستخدم، وأعتقد أنها تبدو رائعة جداً! هل تود رؤيتها؟",
        isMe: true,
        status: "seen",
        time: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      MessageInfoModel(
        message: "بالتأكيد! أرسلها لي في أقرب وقت ممكن.",
        isMe: false,
        status: "delivered",
        time: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      MessageInfoModel(
        message:
            "حسناً، سأقوم برفع الملفات إلى السحابة وإرسال الرابط لك الآن. انتظرني لحظة.",
        isMe: true,
        status: "delivered",
        time: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      MessageInfoModel(
        message: "تمام، بانتظارك.",
        isMe: false,
        status: "sent",
        time: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      MessageInfoModel(
        message:
            "بالمناسبة، هل رأيت التقرير الذي أرسلته صباح اليوم؟ يحتوي على إحصائيات مهمة جداً لنتائج العمل في الفترة الماضية.",
        isMe: false,
        status: "delivered",
        time: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      MessageInfoModel(
        message: "نعم، قرأته وكان ممتازاً! العمل يسير بشكل جيد.",
        isMe: true,
        status: "delivered",
        time: DateTime.now().subtract(const Duration(seconds: 30)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Color avatarColor = Constant
        .listColors[widget.chat.name.length % Constant.listColors.length];
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
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final msg = chatMessages.reversed.toList()[index];
                return ChatBubbleWidget(messageInfo: msg);
              },
            ),
          ),
          MessageChatBarWidget(
            onSend: (text) {
              setState(() {
                chatMessages.add(
                  MessageInfoModel(
                    message: text,
                    isMe: true,
                    status: "sent",
                    time: DateTime.now(),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle(Color avatarColor) {
    PatientModel patient = PatientModel(
      id: 1,
      image: null,
      phoneNumber: 'phoneNumber',
      givenName: 'givenName',
      familyName: 'familyName',
      gender: 'gender',
      phoneNumberVerifiedAt: 'phoneNumberVerifiedAt',
      maritalStatus: 'maritalStatus',
      dateOfBirth: 'dateOfBirth',
      socialHistory: 'socialHistory',
      occupation: 'occupation',
      active: true,
      nationalId: 'nationalId',
      notes: 'notes',
      bloodGroup: 'bloodGroup',
    );
    return Row(
      children: [
        AppAvatar(
          size: 40.r,
          imageUrl: patient.image?.url,
          initials:
              patient.givenName.substring(0, 1) +
              patient.familyName.substring(0, 1),
          color:
              Constant.listColors[(patient.givenName + patient.familyName)
                      .length %
                  Constant.listColors.length],
        ),
        const SizedBox(width: 10),
        Text(
          widget.chat.name,
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
              widget.chat.name[0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              widget.chat.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.call_outlined,
              color: colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              color: colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
            ),
          ),
        ],
      ),
    );
  }
}
