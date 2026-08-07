import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/generated/l10n.dart';

class StateWidget extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final bool isEmpty;
  final VoidCallback onRetry;
  final Widget child;
  final String noDataMsg;

  const StateWidget({
    super.key,
    required this.isLoading,
    required this.error,
    required this.isEmpty,
    required this.onRetry,
    required this.child,
    required this.noDataMsg,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    bool isMobile = DeviceInfo.isMobile(context);
    if (isLoading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: SpinKitFoldingCube(color: colorScheme.primary, size: 20),
            ),
          ),
        ],
      );
    }

    if (error != null) {
      final isNoInternet = error!.toLowerCase().contains('internet');

      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isNoInternet ? Icons.wifi_off : Icons.error_outline,
                  size: 50,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  error!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: onRetry, child: Text(S().retry)),
              ],
            ),
          ),
        ],
      );
    }

    if (isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/no_data.png',
                  width: isMobile ? 350.w : 150.w,
                  height: 150.h,
                ),
                Text(
                  noDataMsg,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withAlpha((0.5 * 255).toInt()),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return child;
  }
}
