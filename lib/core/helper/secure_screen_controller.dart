import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';

class SecureScreenController {
  SecureScreenController._();
  static final SecureScreenController instance = SecureScreenController._();

  int _activeCount = 0;

  Future<void> enter() async {
    _activeCount++;
    if (_activeCount == 1) {
      await ScreenProtector.preventScreenshotOn();
    }
  }

  Future<void> exit() async {
    if (_activeCount > 0) _activeCount--;
    if (_activeCount == 0) {
      await ScreenProtector.preventScreenshotOff();
    }
  }
}

mixin SecureScreenMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    SecureScreenController.instance.enter();
  }

  @override
  void dispose() {
    SecureScreenController.instance.exit();
    super.dispose();
  }
}
