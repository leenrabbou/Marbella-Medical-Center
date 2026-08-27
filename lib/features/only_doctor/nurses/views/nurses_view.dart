import 'package:marbella/features/only_doctor/nurses/viewmodels/encounter_nurses_viewmodel.dart';
import 'package:marbella/features/only_doctor/nurses/widgets/nurse_card.dart';
import 'package:marbella/features/only_doctor/nurses/widgets/nurse_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class NursesView extends StatefulWidget {
  const NursesView({
    super.key,
    required this.isEditable,
    required this.encounterId,
  });
  final bool isEditable;
  final int encounterId;

  @override
  State<NursesView> createState() => _NursesViewState();
}

class _NursesViewState extends State<NursesView> {
  late String locale;
  String? token;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    locale = Localizations.localeOf(context).languageCode;

    token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;
    if (token == null) return;

    await context.read<EncounterNursesViewmodel>().getEncounterNurses(
      locale,
      token,
      widget.encounterId,
    );
  }

  Future<void> _handleRefresh() async {
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final provider = context.watch<EncounterNursesViewmodel>();

    final nurses = provider.encounterNurses;
    final isLoading = provider.isLoadingEncounterNurses;
    final errorMessage = provider.encounterNursesErrorMessage;

    return Scaffold(
      floatingActionButton: widget.isEditable
          ? FloatingActionButton(
              onPressed: () {
                NurseDialogs.showAddNurseDialog(
                  context,
                  encounterId: widget.encounterId,
                  onSuccess: _fetchData,
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 28,
              ),
            )
          : null,
      body: LiquidPullToRefresh(
        color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
        backgroundColor: colorScheme.surface,
        height: 50,
        onRefresh: _handleRefresh,
        child: Center(
          child: StateWidget(
            isLoading: isLoading && nurses.isEmpty,
            error: errorMessage,
            isEmpty: !isLoading && errorMessage == null && nurses.isEmpty,
            onRetry: _handleRefresh,
            noDataMsg: S().no_data,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: nurses.length,
              itemBuilder: (BuildContext context, int index) {
                return NurseCard(
                  nurse: nurses[index],
                  encounterId: widget.encounterId,
                  isEditable: widget.isEditable,
                  onSuccess: _fetchData,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
