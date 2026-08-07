import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marbella/core/helper/device_info.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    required this.onPressed,
    required this.child,
    required this.height,
    required this.width,
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
    required this.textSize,
    required this.color,
    required this.elevation,
    required this.textColor,
  });
  final void Function()? onPressed;
  final Widget? child;
  final double height, width, left, right, top, bottom, textSize, elevation;
  final Color color, textColor;
  @override
  Widget build(BuildContext context) {
    bool isMobile = DeviceInfo.isMobile(context);
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: elevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isMobile ? 18.r : 12.r),
            ),
            backgroundColor: color,
            fixedSize: const Size(double.infinity, double.infinity),
          ),
          child: child,
        ),
      ),
    );
  }
}
