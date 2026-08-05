import 'package:marbella/features/only_doctor/doctor_certificate/viewmodel/certificates_viewmodel.dart';
import 'package:marbella/features/only_doctor/doctor_certificate/widgets/certificate_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class CertificatesView extends StatefulWidget {
  const CertificatesView({super.key});

  @override
  State<CertificatesView> createState() => _CertificatesViewState();
}

class _CertificatesViewState extends State<CertificatesView> {
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

    await context.read<CertificatesViewmodel>().getCertificates(locale, token);
  }

  Future<void> _handleRefresh() async {
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final provider = context.watch<CertificatesViewmodel>();

    final certificates = provider.certificates;
    final isLoading = provider.isLoadingCertificates;
    final errorMessage = provider.certificatesErrorMessage;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 15),
        ),
        title: const SizedBox.shrink(),
      ),
      body: LiquidPullToRefresh(
        color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
        backgroundColor: colorScheme.surface,
        height: 50,
        onRefresh: _handleRefresh,
        child: Center(
          child: StateWidget(
            isLoading: isLoading && certificates.isEmpty,
            error: errorMessage,
            isEmpty: !isLoading && errorMessage == null && certificates.isEmpty,
            onRetry: _handleRefresh,
            noDataMsg: S().no_data,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: certificates.length,
              itemBuilder: (BuildContext context, int index) {
                return DoctorCertificateCard(certificate: certificates[index]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
