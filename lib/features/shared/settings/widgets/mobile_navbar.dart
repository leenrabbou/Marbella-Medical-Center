import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/features/shared/settings/models/nav_item.dart';

class MobileNavbar extends StatelessWidget {
  const MobileNavbar({
    super.key,
    required this.selectedIndex,
    required this.navItems,
    required this.onTap,
  });
  final int selectedIndex;
  final List<NavItem> navItems;
  final ValueChanged<int> onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const Color activeIconColor = Colors.white;
    const Color inactiveIconColor = Color(0xAAFFFFFF);
    const Color activePillColor = Color(0x33FFFFFF);
    return Padding(
      padding: EdgeInsets.all(5.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withAlpha(80),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
          child: Row(
            children: List.generate(navItems.length, (i) {
              final item = navItems[i];
              final isSelected = selectedIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? activePillColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          isSelected ? item.activeIcon : item.icon,
                          size: 20,
                          color: isSelected
                              ? activeIconColor
                              : inactiveIconColor,
                        ),
                      ),
                      const SizedBox(height: 1),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: theme.textTheme.titleSmall!.copyWith(
                          color: isSelected
                              ? activeIconColor
                              : inactiveIconColor,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
