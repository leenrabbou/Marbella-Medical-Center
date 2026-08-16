import 'package:marbella/core/helper/device_info.dart';
import 'package:marbella/core/widgets/style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BriefCard extends StatelessWidget {
  const BriefCard({
    super.key,
    required this.title,
    required this.date,
    required this.text,
    required this.btnTtext,
    required this.imagePath,
    required this.onTap,
  });
  final String title;
  final String date;
  final String text;
  final String btnTtext;
  final String imagePath;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    bool isTablet = DeviceInfo.isTablet(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
      decoration: StyleWidget.cardDecoration(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.h),
              Text(
                date,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(),
              ),
              SizedBox(height: 10.w),
              Text(
                text,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.w),
              btnTtext == '—'
                  ? SizedBox.shrink()
                  : TextButton(
                      onPressed: onTap,
                      child: Text(
                        btnTtext,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.asset(
              imagePath,
              height: isTablet ? 90.h : 60.h,
              width: isTablet ? 88.w : 190.w,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
