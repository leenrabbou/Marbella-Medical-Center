import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/notifications/viewmodel/notification_viewmodel.dart';
import 'package:marbella/features/shared/notifications/widgets/notification_card.dart';
import 'package:marbella/features/shared/settings/viewmodels/localization_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetch());
  }

  Future<void> _fetch() async {
    final locale = Localizations.localeOf(context).languageCode;
    final token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;
    if (token == null) return;
    await context.read<NotificationViewmodel>().fetchNotifications(
      token,
      locale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<NotificationViewmodel>();
    final isArabic = LocalizationViewmodel.isArabic();

    final notifications = provider.notifications;
    final isLoading = provider.isLoading;
    final errorMessage = provider.errorMessage;

    return Scaffold(
      appBar: AppBar(title: Text(S().notifications)),
      body: LiquidPullToRefresh(
        color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
        backgroundColor: colorScheme.surface,
        height: 50,
        onRefresh: _fetch,
        child: StateWidget(
          isLoading: isLoading && notifications.isEmpty,
          error: errorMessage,
          isEmpty: !isLoading && errorMessage == null && notifications.isEmpty,
          onRetry: _fetch,
          noDataMsg: S().no_data,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationCardWidget(
                notification: notification,
                isArabic: isArabic,
                onTap: () => context
                    .read<NotificationViewmodel>()
                    .markOneAsRead(notification.localKey),
              );
            },
          ),
        ),
      ),
    );
  }
}
