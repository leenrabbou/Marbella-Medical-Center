import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/lab_tests/viewmodel/lab_test_viewmodel.dart';
import 'package:marbella/features/only_doctor/lab_tests/widgets/lab_test_card.dart';
import 'package:marbella/features/only_doctor/lab_tests/widgets/lab_tests_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class LabTestTab extends StatefulWidget {
  const LabTestTab({
    super.key,
    required this.patientId,
    required this.status,
    required this.isRequest,
  });
  final int patientId;
  final String? status;
  final bool isRequest;
  @override
  State<LabTestTab> createState() => _LabTestTabState();
}

class _LabTestTabState extends State<LabTestTab> {
  late String locale;
  String? token;
  late LabTestParams params;

  @override
  void initState() {
    super.initState();
    params = LabTestParams(patientId: widget.patientId, status: widget.status);
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

    await context.read<LabTestViewmodel>().getLabTests(locale, token, params);
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
    final provider = context.watch<LabTestViewmodel>();
    final labTests = provider.labTestsFor(params);
    return Scaffold(
      floatingActionButton: widget.isRequest
          ? FloatingActionButton(
              onPressed: () {
                LabTestDialogs.showAddLabTestDialog(
                  context,
                  patientId: widget.patientId,
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
            isLoading:
                provider.isLoadingFor(params) &&
                provider.labTestsFor(params).isEmpty,
            error: provider.errorMessageFor(params),
            isEmpty:
                !provider.isLoadingFor(params) &&
                provider.errorMessageFor(params) == null &&
                labTests.isEmpty,
            onRetry: _handleRefresh,
            noDataMsg: S().no_data,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: labTests.length,
              itemBuilder: (BuildContext context, int index) {
                return LabTestCard(
                  labTest: labTests[index],
                  onDelete: () {
                    LabTestDialogs.showDeleteLabTestDialog(
                      context,
                      labTests[index],
                    );
                  },
                  isRequest: widget.isRequest,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
