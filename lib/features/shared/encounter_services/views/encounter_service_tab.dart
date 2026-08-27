import 'package:marbella/app/app_role.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/encounter_services/viewmodel/encounter_service_viewmodel.dart';
import 'package:marbella/features/shared/encounter_services/widgets/encounter_service_card.dart';
import 'package:marbella/features/shared/encounter_services/widgets/encounter_service_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class EncounterServiceTab extends StatefulWidget {
  const EncounterServiceTab({
    super.key,
    required this.isEditable,
    required this.encounterId,
    required this.status,
  });
  final bool isEditable;
  final int encounterId;
  final String? status;

  @override
  State<EncounterServiceTab> createState() => _EncounterServiceTabState();
}

class _EncounterServiceTabState extends State<EncounterServiceTab> {
  late String locale;
  String? token;

  late EncounterServiceParams _params;

  @override
  void initState() {
    super.initState();

    _params = EncounterServiceParams(
      encounterId: widget.encounterId,
      status: widget.status,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    if (!mounted) return;

    locale = Localizations.localeOf(context).languageCode;

    token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;

    if (!mounted || token == null) return;

    await context.read<EncounterServiceViewmodel>().getEncounterServices(
      locale,
      token!,
      _params,
    );

    if (!mounted) return;

    await context.read<EncounterServiceViewmodel>().getAllServicesList(
      locale,
      token!,
    );
  }

  Future<void> _handleRefresh() async {
    if (!mounted) return;
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final provider = context.watch<EncounterServiceViewmodel>();

    final services = provider.servicesFor(_params);
    final isLoading = provider.isLoadingFor(_params);
    final errorMessage = provider.errorMessageFor(_params);
    final role = context.read<AppRole>();
    bool isMobile = DeviceInfo.isMobile(context);

    return Scaffold(
      floatingActionButton: widget.isEditable && role == AppRole.doctor
          ? FloatingActionButton(
              onPressed: () {
                EncounterServiceDialogs.showAddEncounterServiceDialog(
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
            isLoading: isLoading && services.isEmpty,
            error: errorMessage,
            isEmpty: !isLoading && errorMessage == null && services.isEmpty,
            onRetry: _handleRefresh,
            noDataMsg: S().no_data,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 40.w : 20.w,
                vertical: isMobile ? 0.h : 5.h,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: services.length,
              itemBuilder: (BuildContext context, int index) {
                return EncounterServiceCard(
                  encounterService: services[index],
                  onEdit: () {
                    EncounterServiceDialogs.showEditEncounterServiceDialog(
                      context,
                      services[index],
                      onSuccess: _fetchData,
                    );
                  },
                  onDelete: () {
                    EncounterServiceDialogs.showDeleteEncounterServiceDialog(
                      context,
                      services[index],
                      onSuccess: _fetchData,
                    );
                  },
                  isEditable: widget.isEditable,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
