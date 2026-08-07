import 'package:marbella/app/app_role.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/params/params.dart';
import 'package:marbella/features/shared/encounters/viewmodels/encounter_note_viewmodel.dart';
import 'package:marbella/features/shared/encounters/widgets/encounter_note_card.dart';
import 'package:marbella/features/shared/encounters/widgets/encounter_note_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class EncounterNotesTab extends StatefulWidget {
  const EncounterNotesTab({
    super.key,
    required this.isEditable,
    required this.encounterId,
    required this.patientId,
    required this.status,
  });
  final bool isEditable;
  final int? patientId;
  final int? encounterId;
  final String? status;

  @override
  State<EncounterNotesTab> createState() => _EncounterNotesTabState();
}

class _EncounterNotesTabState extends State<EncounterNotesTab> {
  late String locale;
  String? token;
  late EncounterNoteParams _params;

  @override
  void initState() {
    super.initState();

    _params = EncounterNoteParams(
      patientId: widget.patientId,
      encounterId: widget.encounterId,
      status: widget.status,
    );

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

    await context.read<EncounterNoteViewmodel>().getEncounterNotes(
      locale,
      token,
      _params,
    );
  }

  Future<void> _handleRefresh() async {
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final provider = context.watch<EncounterNoteViewmodel>();

    final notes = provider.notesFor(_params);
    final isLoading = provider.isLoadingFor(_params);
    final errorMessage = provider.errorMessageFor(_params);
    final role = context.read<AppRole>();
    bool isMobile = DeviceInfo.isMobile(context);

    return Scaffold(
      floatingActionButton: widget.isEditable && role == AppRole.doctor
          ? FloatingActionButton(
              onPressed: () {
                EncounterNoteDialogs.showEncounterNoteDialog(
                  context,
                  null,
                  encounterId: widget.encounterId,
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
            isLoading: isLoading && notes.isEmpty,
            error: errorMessage,
            isEmpty: !isLoading && errorMessage == null && notes.isEmpty,
            onRetry: _handleRefresh,
            noDataMsg: S().no_data,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 40.w : 20.w,
                vertical: isMobile ? 0.h : 5.h,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                return EncounterNoteCard(
                  note: notes[index],
                  onEdit: () {
                    EncounterNoteDialogs.showEncounterNoteDialog(
                      context,
                      notes[index],
                    );
                  },
                  onDelete: () {
                    EncounterNoteDialogs.showDeleteEncounterNoteDialog(
                      context,
                      notes[index],
                    );
                  },
                  isEditable: widget.isEditable && role == AppRole.doctor,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
