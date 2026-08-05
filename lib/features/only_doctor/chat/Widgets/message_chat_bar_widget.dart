import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageChatBarWidget extends StatefulWidget {
  final Function(String) onSend;
  const MessageChatBarWidget({super.key, required this.onSend});

  @override
  State<MessageChatBarWidget> createState() => _MessageChatBarWidgetState();
}

class _MessageChatBarWidgetState extends State<MessageChatBarWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.onSurface.withAlpha((0.06 * 255).toInt()),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withAlpha((0.05 * 255).toInt()),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: colorScheme.onSurface.withAlpha(
                          (0.5 * 255).toInt(),
                        ),
                        size: 22,
                      ),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: (text) =>
                            setState(() => _isWriting = text.trim().isNotEmpty),
                        maxLines: 5,
                        minLines: 1,
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: colorScheme.onSurface.withAlpha(
                                  (0.5 * 255).toInt(),
                                ),
                              ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    if (!_isWriting) ...[
                      IconButton(
                        icon: Icon(
                          Icons.attach_file_rounded,
                          color: colorScheme.onSurface.withAlpha(
                            (0.5 * 255).toInt(),
                          ),
                          size: 21,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: colorScheme.onSurface.withAlpha(
                            (0.5 * 255).toInt(),
                          ),
                          size: 21,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 4),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: _isWriting
                  ? Container(
                      key: const ValueKey('send'),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          final text = _controller.text.trim();
                          if (text.isEmpty) return;
                          widget.onSend(text);
                          _controller.clear();
                          setState(() => _isWriting = false);
                        },
                      ),
                    )
                  : Container(
                      key: const ValueKey('mic'),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(
                          (0.08 * 255).toInt(),
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.mic_none_rounded,
                          color: colorScheme.primary,
                          size: 22,
                        ),
                        onPressed: () {},
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
