import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withAlpha(80),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? activePillColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            size: 24,
                            color: isSelected
                                ? activeIconColor
                                : inactiveIconColor,
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: theme.textTheme.titleMedium!.copyWith(
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
      ),
    );
  }
}
