import 'package:marbella/core/params/params.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/patient_medications/viewmodel/patient_medication_viewmodel.dart';
import 'package:marbella/features/only_doctor/patients/widgets/chip_item.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ActiveMedicationsCard extends StatefulWidget {
  const ActiveMedicationsCard({super.key, required this.patientId});
  final int patientId;
  @override
  State<ActiveMedicationsCard> createState() => _ActiveMedicationsCardState();
}

class _ActiveMedicationsCardState extends State<ActiveMedicationsCard> {
  late PatientMedicationsParams _params;
  late String locale;
  String? token;
  @override
  void initState() {
    super.initState();
    _params = PatientMedicationsParams(
      patientId: widget.patientId,
      doctorId: null,
      encounterId: null,
      status: 'active',
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
    await context.read<PatientMedicationViewmodel>().getPatientMedications(
      locale,
      token,
      _params,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PatientMedicationViewmodel>();
    final activeConditions = provider.medicationsFor(_params);
    final colorScheme = Theme.of(context).colorScheme;
    final displayedMedications = activeConditions.take(3).toList();
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
                S().active_medications,
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
          if (provider.isLoadingFor(_params))
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: SpinKitFadingGrid(
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
          if (displayedMedications.isEmpty && !provider.isLoadingFor(_params))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                S().no_active_medications,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withAlpha((0.5 * 255).toInt()),
                ),
              ),
            )
          else
            ...List.generate(displayedMedications.length, (index) {
              final medication = displayedMedications[index];
              final isLast = index == displayedMedications.length - 1;
              return Column(
                children: [
                  ChipeItem(
                    text: medication.medication.code.display,
                    icon: Icons.medication_outlined,
                    number: medication.dosage,
                    isCondition: false,
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
