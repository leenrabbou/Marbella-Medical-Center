import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marbella/generated/l10n.dart';

class CirtificatesDialogs {
  void showImageDialog(BuildContext context, String imageUrl) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: colorScheme.surface.withAlpha(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Container(
                  color: Colors.white.withAlpha(10),
                  width: double.infinity,
                  height: double.infinity,
                  child: InteractiveViewer(
                    maxScale: 5,
                    minScale: 0.8,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) return child;

                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: frame != null
                                  ? child
                                  : SpinKitFadingGrid(
                                      color: Colors.white,
                                      size: 20,
                                    ),
                            );
                          },
                      errorBuilder: (context, error, stackTrace) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.redAccent,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                S().failed_to_load_image,
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: Text(S().close),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withAlpha(
                      (0.85 * 255).toInt(),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
