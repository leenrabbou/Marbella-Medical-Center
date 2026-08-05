import 'package:marbella/features/only_doctor/medications/viewmodels/medication_viewmodel.dart';
import 'package:marbella/features/only_doctor/medications/widgets/medication_dialogs.dart';
import 'package:marbella/features/only_doctor/medications/widgets/medication_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class MedicationView extends StatefulWidget {
  const MedicationView({super.key});
  @override
  State<MedicationView> createState() => _MedicationViewState();
}

class _MedicationViewState extends State<MedicationView> {
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

    await context.read<MedicationViewmodel>().getMedications(locale, token);
  }

  Future<void> _handleRefresh() async {
    await _fetchData();
  }

  String safeText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S().not_available;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final provider = context.watch<MedicationViewmodel>();
    final medications = provider.mediactionsList;
    return Scaffold(
      appBar: AppBar(title: Text(S().medications_tab)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MedicationDialogs.showMedicationDialog(context, null);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      body: LiquidPullToRefresh(
        color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
        backgroundColor: colorScheme.surface,
        height: 50,
        onRefresh: _handleRefresh,
        child: Center(
          child: StateWidget(
            isLoading:
                provider.isLoadingList && provider.mediactionsList.isEmpty,
            error: provider.getListErrorMessage,
            isEmpty:
                !provider.isLoadingList &&
                provider.getListErrorMessage == null &&
                medications.isEmpty,
            onRetry: _handleRefresh,
            noDataMsg: S().no_data,
            child: ListView.builder(
              padding: EdgeInsets.all(20.r),
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: medications.length,
              itemBuilder: (BuildContext context, int index) {
                return MedicationCard(
                  medication: medications[index],
                  onEdit: () {
                    MedicationDialogs.showMedicationDialog(
                      context,
                      medications[index],
                    );
                  },
                  onDelete: () {
                    MedicationDialogs.showDeleteMedicationDialog(
                      context,
                      medications[index],
                    );
                  },
                  showDescreption: true,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
