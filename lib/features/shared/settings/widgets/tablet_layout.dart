import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/features/shared/settings/models/nav_item.dart';
import 'package:marbella/features/shared/settings/views/main_content_view.dart';

class TabletLayout extends StatefulWidget {
  const TabletLayout({
    super.key,
    required this.selectedIndex,
    required this.navItems,
    required this.onDestinationSelected,
  });
  final int selectedIndex;
  final List<NavItem> navItems;
  final ValueChanged<int> onDestinationSelected;
  @override
  State<TabletLayout> createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<TabletLayout> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withAlpha((0.05 * 255).toInt()),
                  offset: const Offset(10, 0),
                  spreadRadius: -8,
                ),
              ],
            ),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: isExpanded ? 220 : 90,
            child: Material(
              color: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isExpanded ? 20 : 16,
                        vertical: 22,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/imglogo1.png",
                            width: 35.w,
                            height: 35.h,
                          ),
                          if (isExpanded) ...[
                            Expanded(
                              child: Text(
                                'arbella',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                  fontFamily: 'AlexBrush',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        itemCount: widget.navItems.length,
                        itemBuilder: (_, i) {
                          final item = widget.navItems[i];
                          final isSelected = widget.selectedIndex == i;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                splashColor: colorScheme.primary.withAlpha(25),
                                highlightColor: colorScheme.primary.withAlpha(
                                  15,
                                ),
                                onTap: () => widget.onDestinationSelected(i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isExpanded ? 14 : 0,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colorScheme.primary.withAlpha(
                                            (0.8 * 255).toInt(),
                                          )
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: isExpanded
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.center,
                                    children: [
                                      if (isExpanded) const SizedBox(width: 13),
                                      Icon(
                                        isSelected
                                            ? item.activeIcon
                                            : item.icon,
                                        size: isExpanded ? 22 : 28,
                                        color: isSelected
                                            ? Colors.white
                                            : colorScheme.onSurface.withAlpha(
                                                (0.5 * 255).toInt(),
                                              ),
                                      ),
                                      if (isExpanded) ...[
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            item.label,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  fontWeight: isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : colorScheme.onSurface
                                                            .withAlpha(
                                                              (0.4 * 255)
                                                                  .toInt(),
                                                            ),
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(child: MainContentView(selectedIndex: widget.selectedIndex)),
      ],
    );
  }
}
