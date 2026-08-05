import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/conditions/viewmodels/condition_viewmodel.dart';
import 'package:marbella/features/only_doctor/patients/widgets/chip_item.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ActiveConditionsCard extends StatefulWidget {
  const ActiveConditionsCard({super.key, required this.patientId});
  final int patientId;
  @override
  State<ActiveConditionsCard> createState() => _ActiveConditionsCardState();
}

class _ActiveConditionsCardState extends State<ActiveConditionsCard> {
  late ConditionParams _params;
  @override
  void initState() {
    super.initState();
    _params = ConditionParams(
      encounterId: null,
      clinicalStatus: 'active',
      verificationStatus: null,
      patientId: widget.patientId,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchConditionsData();
    });
  }

  String? get _token =>
      context.read<AuthViewmodel>().response?.data?.token ??
      context.read<AuthViewmodel>().userFromCache?.data?.token;
  String get _locale => Localizations.localeOf(context).languageCode;
  Future<void> _fetchConditionsData() async {
    if (!mounted) return;
    await context.read<ConditionViewmodel>().getEncounterConditions(
      _locale,
      _token,
      _params,
    );
  }

  @override
  Widget build(BuildContext context) {
    final conditionProvider = context.watch<ConditionViewmodel>();
    final activeConditions = conditionProvider.conditionsFor(_params);
    final colorScheme = Theme.of(context).colorScheme;
    final displayedConditions = activeConditions.take(3).toList();
    final hasMore = activeConditions.length > 3;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: StyleWidget.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S().active_conditions,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (hasMore)
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    DefaultTabController.of(context).animateTo(2);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    child: Text(
                      S().see_all,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(
            height: 3,
            color: colorScheme.onSurface.withAlpha((0.1 * 255).toInt()),
          ),
          if (conditionProvider.isLoadingFor(_params))
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: SpinKitFadingGrid(
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
          if (displayedConditions.isEmpty &&
              !conditionProvider.isLoadingFor(_params))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                S().no_active_conditions,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withAlpha((0.5 * 255).toInt()),
                ),
              ),
            )
          else
            ...List.generate(displayedConditions.length, (index) {
              final condition = displayedConditions[index];
              final isLast = index == displayedConditions.length - 1;
              return Column(
                children: [
                  ChipeItem(
                    text: condition.code.display,
                    icon: Icons.medical_information_outlined,
                    number: '',
                    isCondition: true,
                  ),
                  if (!isLast)
                    Divider(
                      height: 3,
                      color: colorScheme.onSurface.withAlpha(
                        (0.1 * 255).toInt(),
                      ),
                    ),
                ],
              );
            }),
        ],
      ),
    );
  }
}
