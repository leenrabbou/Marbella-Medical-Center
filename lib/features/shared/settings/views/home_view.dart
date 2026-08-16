import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:marbella/app/app_role.dart';
import 'package:flutter/material.dart';
import 'package:marbella/core/databases/api/api_services.dart';
import 'package:marbella/core/databases/cache/cache_keys.dart';
import 'package:marbella/core/databases/cache/secure_storage_service.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/features/only_doctor/chat/viewmodel/chat_viewmodel.dart';
import 'package:marbella/features/shared/auth/models/user_model.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_token_provider.dart';
import 'package:marbella/features/shared/notifications/service/pusher_service.dart';
import 'package:marbella/features/shared/settings/models/nav_item.dart';
import 'package:marbella/features/shared/settings/views/main_content_view.dart';
import 'package:marbella/features/shared/settings/widgets/mobile_navbar.dart';
import 'package:marbella/features/shared/settings/widgets/tablet_layout.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomePageState();
}

class _HomePageState extends State<HomeView> {
  int selectedIndex = 0;

  Future<UserModel?> init() async {
    final dataString = await SecureStorageService.instance.read(
      key: CacheKeys.userKey,
    );

    if (dataString != null) {
      final dataMap = jsonDecode(dataString) as Map<String, dynamic>;
      return UserModel.fromJson(dataMap);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _initPusher();
  }

  Future<void> _initPusher() async {
    final user = await init();
    if (user != null && mounted) {
      PusherService(
        apiService: ApiServices(
          dio: Dio(),
          tokenProvider: SecureStorageTokenProvider(
            SecureStorageService.instance,
          ),
        ),
      ).initPusher(user.id, chatViewmodel: context.read<ChatViewmodel>());
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = context.read<AppRole>();
    List<NavItem> navItems = [
      NavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.dashboard_outlined,
        label: S().home,
      ),
      NavItem(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_outline,
        label: S().profile,
      ),
      if (role == AppRole.doctor)
        NavItem(
          icon: Icons.calendar_month_outlined,
          activeIcon: Icons.calendar_month_outlined,
          label: S().appointments,
        ),
      NavItem(
        icon: Icons.schedule_outlined,
        activeIcon: Icons.schedule_outlined,
        label: S().schedule,
      ),
      if (role == AppRole.doctor)
        NavItem(
          icon: Icons.group_outlined,
          activeIcon: Icons.group_outlined,
          label: S().patients,
        ),
      if (role == AppRole.doctor)
        NavItem(
          icon: Icons.medication_outlined,
          activeIcon: Icons.medication_outlined,
          label: S().medications_tab,
        ),
      if (role == AppRole.doctor)
        NavItem(
          icon: Icons.forum_outlined,
          activeIcon: Icons.forum_outlined,
          label: S().chats,
        ),
      NavItem(
        icon: Icons.notifications_outlined,
        activeIcon: Icons.notifications_outlined,
        label: S().notifications,
      ),
      NavItem(
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings_outlined,
        label: S().settings,
      ),
    ];
    final bool isTablet = DeviceInfo.isTablet(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: isTablet
            ? TabletLayout(
                selectedIndex: selectedIndex,
                navItems: navItems,
                onDestinationSelected: (i) => setState(() => selectedIndex = i),
              )
            : MainContentView(selectedIndex: selectedIndex),
      ),
      bottomNavigationBar: isTablet
          ? null
          : MobileNavbar(
              selectedIndex: selectedIndex,
              navItems: navItems,
              onTap: (i) => setState(() => selectedIndex = i),
            ),
    );
  }
}
