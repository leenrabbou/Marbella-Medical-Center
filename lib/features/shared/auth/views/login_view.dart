import 'package:marbella/app/app_role.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_view_doctor.dart';
import 'login_view_nurse.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.read<AppRole>();
    return switch (role) {
      AppRole.doctor => const LoginViewDoctor(),
      AppRole.nurse => const LoginViewNurse(),
    };
  }
}
