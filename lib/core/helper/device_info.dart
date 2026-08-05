import 'package:flutter/material.dart';

class DeviceInfo {
  static Size screenSize(BuildContext context) => MediaQuery.of(context).size;

  static double width(BuildContext context) => screenSize(context).width;

  static double height(BuildContext context) => screenSize(context).height;

  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    return size.width >= 800 && orientation == Orientation.landscape;
  }

  static bool isMobile(BuildContext context) {
    return !isTablet(context);
  }
}
