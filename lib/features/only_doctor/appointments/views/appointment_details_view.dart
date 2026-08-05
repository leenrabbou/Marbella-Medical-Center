import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/features/only_doctor/appointments/viewmodels/appointments_viewmodel.dart';
import 'package:marbella/features/only_doctor/appointments/widgets/header_widget.dart';
import 'package:marbella/features/only_doctor/appointments/widgets/info_card_widget.dart';
import 'package:marbella/features/only_doctor/appointments/widgets/note_card_widget.dart';
import 'package:marbella/features/only_doctor/appointments/widgets/time_card_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/only_doctor/patients/viewmodels/patients_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:marbella/features/only_doctor/appointments/models/appointment_model.dart';
import 'package:provider/provider.dart';

class AppointmentDetailsView extends StatefulWidget {
  const AppointmentDetailsView({
    super.key,
    required this.appointment,
    required this.isFromPatient,
  });
  final AppointmentModel appointment;

  final bool isFromPatient;
  @override
  State<AppointmentDetailsView> createState() => _AppointmentDetailsViewState();
}

class _AppointmentDetailsViewState extends State<AppointmentDetailsView> {
  late AppointmentModel localAppointment;

  Uint8List? imgBytes;
  @override
  void initState() {
    super.initState();
    localAppointment = widget.appointment;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPatientImage());
  }

  Future<void> _handleRefresh() async {
    final authProvider = context.read<AuthViewmodel>();
    final appointmentProvider = context.read<AppointmentsViewmodel>();

    final token =
        authProvider.response?.data?.token ??
        authProvider.userFromCache?.data?.token;

    final locale = Localizations.localeOf(context).languageCode;

    await appointmentProvider.getAppointmentDetails(
      locale,
      token,
      localAppointment.id,
    );

    if (mounted) {
      setState(() {
        localAppointment =
            appointmentProvider.appointmentDetails ?? localAppointment;
        if (appointmentProvider.appointmentDetails?.patient.image?.url !=
            null) {
          _loadPatientImage();
        }
      });
    }
  }

  Future<void> _loadPatientImage() async {
    if (widget.appointment.patient.image?.url == null) return;
    final token =
        context.read<AuthViewmodel>().response?.data?.token ??
        context.read<AuthViewmodel>().userFromCache?.data?.token;
    final locale = Localizations.localeOf(context).languageCode;
    final bytes = await context.read<PatientsViewmodel>().getPatientImage(
      locale,
      token,
      widget.appointment.patient.image!.url,
    );
    if (!mounted || bytes == null || bytes.isEmpty) return;
    setState(() => imgBytes = bytes);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    Color avatarColor =
        Constant.listColors[(widget.appointment.patient.givenName +
                    widget.appointment.patient.familyName)
                .length %
            Constant.listColors.length];
    final statusColor = Constant.statusColor(widget.appointment.status);

    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
        backgroundColor: colorScheme.surface,
        height: 50,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 130.h,
              pinned: true,
              backgroundColor: Color.alphaBlend(
                Colors.black.withAlpha(60),
                statusColor,
              ),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                  color: Colors.white,
                ),
              ),
              title: const SizedBox.shrink(),
              actions: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.2 * 255).toInt()),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    widget.appointment.status,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Color.alphaBlend(
                    Colors.black.withAlpha(40),
                    statusColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: HeaderWidget(
                      appointment: widget.appointment,
                      imgBytes: imgBytes,
                      isFromPatient: widget.isFromPatient,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TimeCardWidget(
                            appointment: widget.appointment,
                            statusColor: statusColor,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: InfoCardWidget(
                            icon: Icons.local_hospital_outlined,
                            iconColor: colorScheme.primary,
                            label: S().clinic,
                            value: widget.appointment.clinic.name,
                            valueColor: colorScheme.onSurface,
                            isPrice: false,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    Row(
                      children: [
                        Expanded(
                          child: InfoCardWidget(
                            icon: Icons.medical_services_outlined,
                            iconColor: colorScheme.primary,
                            label: S().service,
                            value: widget.appointment.service.name,
                            valueColor: colorScheme.onSurface,
                            isPrice: false,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: InfoCardWidget(
                            icon: Icons.credit_card,
                            iconColor: colorScheme.primary,
                            label: S().price,
                            value: Constant.formatPrice(
                              widget.appointment.price,
                            ),
                            valueColor: colorScheme.primary,
                            isPrice: true,
                          ),
                        ),
                      ],
                    ),

                    if (widget.appointment.reason.isNotEmpty) ...[
                      SizedBox(height: 10.h),
                      NoteCardWidget(
                        icon: Icons.help_outline_rounded,
                        title: S().visit_reason,
                        content: widget.appointment.reason,
                        color: avatarColor,
                      ),
                    ],

                    if (widget.appointment.notes != null) ...[
                      SizedBox(height: 10.h),
                      NoteCardWidget(
                        icon: Icons.notes_rounded,
                        title: S().notes,
                        content: widget.appointment.notes!,
                        color: colorScheme.primary,
                      ),
                    ],

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
