import 'package:marbella/app/app_role.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/only_doctor/medications/widgets/medication_card.dart';
import 'package:marbella/features/shared/patient_medications/models/patient_medication_model.dart';
import 'package:marbella/features/shared/patient_medications/viewmodel/patient_medication_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class PatientMedicationDetailsView extends StatefulWidget {
  const PatientMedicationDetailsView({
    super.key,
    required this.patientMedication,
    required this.isEditable,
    this.onEdit,
    this.onDelete,
  });
  final PatientMedicationModel patientMedication;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isEditable;

  @override
  State<PatientMedicationDetailsView> createState() =>
      _PatientMedicationDetailsViewState();
}

class _PatientMedicationDetailsViewState
    extends State<PatientMedicationDetailsView> {
  late PatientMedicationModel _patientMedication;

  @override
  void initState() {
    super.initState();
    _patientMedication = widget.patientMedication;
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchDetails());
  }

  String? get _token =>
      context.read<AuthViewmodel>().response?.data?.token ??
      context.read<AuthViewmodel>().userFromCache?.data?.token;

  String get _locale => Localizations.localeOf(context).languageCode;

  Future<void> _fetchDetails() async {
    if (!mounted) return;
    await context
        .read<PatientMedicationViewmodel>()
        .getPatientMedicationDetails(_locale, _token, _patientMedication.id);

    if (!mounted) return;
    final updated = context
        .read<PatientMedicationViewmodel>()
        .patientMedicationDetailsFor(_patientMedication.id);

    if (updated != null) {
      setState(() => _patientMedication = updated);
    }
  }

  Future<void> _handleRefresh() => _fetchDetails();

  bool get _isActive {
    final untilRaw = _patientMedication.untilDate;
    if (untilRaw == null || untilRaw.trim().isEmpty) return true;
    final until = DateTime.tryParse(untilRaw);
    if (until == null) return true;
    final today = DateTime.now();
    final untilDateOnly = DateTime(until.year, until.month, until.day);
    final todayDateOnly = DateTime(today.year, today.month, today.day);
    return !todayDateOnly.isAfter(untilDateOnly);
  }

  @override
  Widget build(BuildContext context) {
    final role = context.read<AppRole>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final medication = _patientMedication.medication;
    final statusColor = _isActive
        ? const Color(0xFF22C55E)
        : colorScheme.onSurface.withAlpha((0.35 * 255).toInt());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 15),
        ),
        title: const SizedBox.shrink(),
        actions: [
          widget.isEditable && role == AppRole.doctor
              ? PopupMenuButton<String>(
                  color: colorScheme.surface,
                  icon: const Icon(Icons.more_vert),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') widget.onEdit?.call();
                    if (value == 'delete') widget.onDelete?.call();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, size: 20),
                          const SizedBox(width: 10),
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
                )
              : const SizedBox.shrink(),
          SizedBox(width: 8.w),
        ],
      ),
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
        backgroundColor: colorScheme.surface,
        height: 50,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  MedicationCard(
                    medication: medication,
                    showDescreption: false,
                    isFromDetailsView: false,
                  ),
                  Positioned(
                    top: 20.h,
                    right: 20.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.06 * 255).toInt()),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            _isActive ? S().active : S().ended,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              _sectionCard(
                context,
                title: S().prescription_details,
                children: [
                  _detailRow(
                    context,
                    icon: Icons.medication_liquid_outlined,
                    label: S().medication_dosage,
                    value: _patientMedication.dosage,
                  ),
                  _detailRow(
                    context,
                    icon: Icons.alt_route_outlined,
                    label: S().route,
                    value: _patientMedication.route,
                  ),
                  _detailRow(
                    context,
                    icon: Icons.timelapse_outlined,
                    label: S().duration,
                    value:
                        '${_patientMedication.durationValue} ${_patientMedication.durationUnit}',
                  ),
                  _detailRow(
                    context,
                    icon: Icons.event_busy_outlined,
                    label: S().until_date,
                    value: _patientMedication.untilDate != null
                        ? Constant.formatDate(
                            context,
                            _patientMedication.untilDate!,
                          )
                        : '-',
                    isLast: true,
                  ),
                ],
              ),
              if (medication.description != null) ...[
                SizedBox(height: 10.h),
                _sectionCard(
                  context,
                  title: S().medication_description,
                  children: [
                    Text(
                      medication.description ?? '-',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withAlpha(
                          (0.75 * 255).toInt(),
                        ),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
              if (_patientMedication.notes != null &&
                  _patientMedication.notes!.trim().isNotEmpty) ...[
                SizedBox(height: 10.h),
                _sectionCard(
                  context,
                  title: S().notes,
                  icon: Icons.sticky_note_2_outlined,
                  children: [
                    Text(
                      _patientMedication.notes!,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).toInt()),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: colorScheme.primary),
                SizedBox(width: 8.w),
              ],
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha((0.08 * 255).toInt()),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: colorScheme.primary),
            ),
            SizedBox(width: 12.w),
            SizedBox(
              width: 100.w,
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          SizedBox(height: 12.h),
          Divider(
            height: 0.5,
            color: colorScheme.onSurface.withAlpha((0.06 * 255).toInt()),
          ),
          SizedBox(height: 12.h),
        ],
      ],
    );
  }
}
