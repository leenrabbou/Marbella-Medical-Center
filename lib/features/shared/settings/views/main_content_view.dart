import 'package:marbella/app/app_role.dart';
import 'package:marbella/features/only_doctor/chat/Views/chats_shell_view.dart';
import 'package:marbella/features/only_doctor/medications/views/medication_view.dart';
import 'package:marbella/features/shared/encounters/views/only_nurse/encounters_view.dart';
import 'package:flutter/material.dart';
import 'package:marbella/features/only_doctor/appointments/views/all_appointments_view.dart';
import 'package:marbella/features/shared/notifications/views/notification_view.dart';
import 'package:marbella/features/shared/schedule/views/schedule_view.dart';
import 'package:marbella/features/only_doctor/patients/views/patients_view.dart';
import 'package:marbella/features/shared/profile/views/profile_view.dart';
import 'package:marbella/features/shared/settings/views/settings_view.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class MainContentView extends StatelessWidget {
  final int selectedIndex;
  const MainContentView({super.key, required this.selectedIndex});
  @override
  Widget build(BuildContext context) {
    final role = context.read<AppRole>();
    switch (selectedIndex) {
      case 0:
        return EncountersView();
      case 1:
        return ProfileView();
      case 2:
        return role == AppRole.doctor ? AllAppointmentsView() : ScheduleView();
      case 3:
        return role == AppRole.doctor ? ScheduleView() : SettingsView();
      case 4:
        return role == AppRole.doctor
            ? PatientsView(isCurrent: false)
            : Center(child: Text(S().page_not_found));
      case 5:
        return role == AppRole.doctor
            ? MedicationView()
            : Center(child: Text(S().page_not_found));
      case 6:
        return role == AppRole.doctor
            ? ChatsShellView()
            : Center(child: Text(S().page_not_found));
      case 7:
        return role == AppRole.doctor
            ? NotificationsView()
            : Center(child: Text(S().page_not_found));
      case 8:
        return role == AppRole.doctor
            ? SettingsView()
            : Center(child: Text(S().page_not_found));
      default:
        return Center(child: Text(S().page_not_found));
    }
  }
}
