import 'dart:ui';

import 'package:flutter/material.dart';

class DeviceUtilities {
  DeviceUtilities._();

  static FlutterView get firstFlutterView {
    return WidgetsBinding.instance.platformDispatcher.views.first;
  }

  static final pixelRatio = firstFlutterView.devicePixelRatio;

  static final double bottomBarHeight = () {
    return firstFlutterView.padding.bottom / pixelRatio;
  }();

  static final screenWidth = () {
    final flutterView = WidgetsBinding.instance.platformDispatcher.views.first;
    return flutterView.physicalSize.width / flutterView.devicePixelRatio;
  }();

  static final screenHeight = () {
    final flutterView = WidgetsBinding.instance.platformDispatcher.views.first;
    return flutterView.physicalSize.height / flutterView.devicePixelRatio;
  }();
}
