import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/only_doctor/medications/models/medication_model.dart';
import 'package:marbella/features/only_doctor/medications/viewmodels/interaction_viewmodel.dart';
import 'package:marbella/features/only_doctor/medications/viewmodels/medication_viewmodel.dart';
import 'package:marbella/features/only_doctor/medications/widgets/condition_interactions_tab.dart';
import 'package:marbella/features/only_doctor/medications/widgets/drug_interactions_tab.dart';
import 'package:marbella/features/only_doctor/medications/widgets/interactions_dialogs.dart';
import 'package:marbella/features/only_doctor/medications/widgets/medication_card.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class MedicationDetailsView extends StatefulWidget {
  final MedicationModel medication;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MedicationDetailsView({
    super.key,
    required this.medication,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<MedicationDetailsView> createState() => _MedicationDetailsViewState();
}

class _MedicationDetailsViewState extends State<MedicationDetailsView>
    with SingleTickerProviderStateMixin {
  late MedicationModel localeMedication;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    localeMedication = widget.medication;
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final locale = Localizations.localeOf(context).languageCode;
    final authViewModel = context.read<AuthViewmodel>();
    final token =
        authViewModel.response?.data?.token ??
        authViewModel.userFromCache?.data?.token;

    if (token == null) return;

    final interactionVm = context.read<InteractionViewmodel>();
    final medicationVm = context.read<MedicationViewmodel>();

    await Future.wait([
      medicationVm.getMedicationDetails(locale, token, widget.medication.id),
      interactionVm.getInteractions(
        locale,
        token,
        InteractionParams(
          medicationId: widget.medication.id,
          interactableType: 'medication',
        ),
      ),
      interactionVm.getInteractions(
        locale,
        token,
        InteractionParams(
          medicationId: widget.medication.id,
          interactableType: 'code',
        ),
      ),
    ]);

    if (!mounted) return;

    if (medicationVm.medicationDetails != null) {
      setState(() {
        localeMedication = medicationVm.medicationDetails!;
      });
    }
  }

  void _openAddInteractionDialog() {
    final isDrugTab = _tabController.index == 0;
    final interactableType = isDrugTab ? 'medication' : 'code';

    InteractionsDialogs.showAddInteractionsDialog(
      context,
      medicationId: widget.medication.id,
      interactableType: interactableType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final provider = context.watch<InteractionViewmodel>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 15),
        ),
        actions: [
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.more_vert,
              size: 20,
              color: colorScheme.onSurface.withAlpha((0.5 * 255).toInt()),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            color: colorScheme.surface,
            onSelected: (value) {
              if (value == 'edit') widget.onEdit?.call();
              if (value == 'delete') widget.onDelete?.call();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: colorScheme.onSurface.withAlpha(
                        (0.5 * 255).toInt(),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      S().edit,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      S().delete,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddInteractionDialog,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3,
        icon: const Icon(Icons.add_rounded),
        label: AnimatedBuilder(
          animation: _tabController,
          builder: (context, child) {
            final isDrugTab = _tabController.index == 0;
            return Text(
              isDrugTab ? 'إضافة تعارض دوائي' : 'إضافة تعارض مرضي',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),

      body: LiquidPullToRefresh(
        onRefresh: _fetchData,
        color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
        backgroundColor: colorScheme.surface,
        height: 50,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              MedicationCard(
                medication: localeMedication,
                showDescreption: true,
                isFromDetailsView: true,
              ),
              TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: colorScheme.primary,
                unselectedLabelColor: colorScheme.onSurface.withAlpha(
                  (0.6 * 255).toInt(),
                ),
                labelStyle: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(child: Text(S().drugInteractionsTitle)),
                  Tab(child: Text(S().conditions_interactions)),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    provider.isLoadingList
                        ? Center(
                            child: SpinKitFoldingCube(
                              color: colorScheme.primary,
                              size: 20,
                            ),
                          )
                        : DrugInteractionsTab(
                            drugInteractions: provider.drugInteractionsList,
                          ),
                    provider.isLoadingList
                        ? Center(
                            child: SpinKitFoldingCube(
                              color: colorScheme.primary,
                              size: 20,
                            ),
                          )
                        : ConditionInteractionsTab(
                            conditionInteractions:
                                provider.conditionInteractionsList,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
