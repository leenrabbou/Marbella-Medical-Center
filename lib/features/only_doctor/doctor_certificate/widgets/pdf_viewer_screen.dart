import 'package:marbella/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key, required this.url, required this.title});
  final String url;
  final String title;

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 15),
        ),
        title: const SizedBox.shrink(),
      ),
      body: _hasError
          ? _buildErrorState()
          : SfPdfViewer.network(
              widget.url,
              onDocumentLoadFailed: (details) {
                setState(() => _hasError = true);
              },
              onDocumentLoaded: (details) {},
              onPageChanged: (details) {},
            ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              S().check_your_internet_connection_and_try_again,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => setState(() => _hasError = false),
              child: Text(S().retry),
            ),
          ],
        ),
      ),
    );
  }
}
