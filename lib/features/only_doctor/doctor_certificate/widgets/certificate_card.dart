import 'package:marbella/core/helper/constant.dart';
import 'package:marbella/core/widgets/snackbar_widget.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:marbella/features/only_doctor/doctor_certificate/models/certificate_model.dart';
import 'package:marbella/features/only_doctor/doctor_certificate/widgets/cirtificates_dialogs.dart';
import 'package:marbella/features/only_doctor/doctor_certificate/widgets/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/generated/l10n.dart';

class DoctorCertificateCard extends StatelessWidget {
  const DoctorCertificateCard({super.key, required this.certificate});
  final CertificateModel certificate;

  void _openCertificateFile(BuildContext context) {
    final url = certificate.file?.url;

    if (url == null) {
      AppSnackbar.show(
        context,
        message: S().no_file_available,
        type: SnackbarType.info,
      );

      return;
    }

    final bool isImage = certificate.file!.mimeType.startsWith('image/');
    isImage
        ? CirtificatesDialogs().showImageDialog(context, url)
        : Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  PdfViewerScreen(url: url, title: certificate.title),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ststusColor = Constant.statusColor(certificate.status);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: () => _openCertificateFile(context),
        child: Container(
          decoration: StyleWidget.cardDecoration(context),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 46.h,
                    width: 46.w,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.workspace_premium_rounded,
                      color: colorScheme.primary,
                      size: 25.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          certificate.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          certificate.issuer,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withAlpha(200),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: ststusColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      certificate.status.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: ststusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Divider(color: colorScheme.onSurface.withAlpha(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 18,
                        color: colorScheme.onSurface.withAlpha(200),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        Constant.formatDate(context, certificate.issuedAt),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
