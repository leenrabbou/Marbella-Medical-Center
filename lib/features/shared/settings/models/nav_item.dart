import 'package:flutter/cupertino.dart';
class NavItem {
  const NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon, activeIcon;
  final String label;
}