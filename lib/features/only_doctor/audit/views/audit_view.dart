import 'package:marbella/features/only_doctor/audit/viewmodel/audit_viewmodel.dart';
import 'package:marbella/features/only_doctor/audit/widgets/audit_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marbella/core/widgets/state_widget.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class AuditView extends StatefulWidget {
  const AuditView({super.key, required this.id, required this.endPoint});
  final int id;
  final String endPoint;
  @override
  State<AuditView> createState() => _AuditViewState();
}

class _AuditViewState extends State<AuditView> {
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

    await context.read<AuditViewmodel>().getAudit(
      locale,
      token,
      widget.id,
      widget.endPoint,
    );
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
    final provider = context.watch<AuditViewmodel>();
    int id = widget.id;
    final auditList = provider.auditFor(id) ?? [];
    final isLoading = provider.isLoadingAuditFor(id);
    final errorMsg = provider.errorMessageAuditFor(id);
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
            isLoading: isLoading && auditList.isEmpty,
            error: errorMsg,
            isEmpty: !isLoading && errorMsg == null && auditList.isEmpty,
            onRetry: _handleRefresh,
            noDataMsg: S().no_data,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: auditList.length,
              itemBuilder: (BuildContext context, int index) {
                return AuditItem(
                  log: auditList[index],
                  isLast: index == auditList.length - 1,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
