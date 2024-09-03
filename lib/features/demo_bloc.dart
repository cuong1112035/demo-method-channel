import 'dart:convert';

import 'package:app/core/bloc_provider.dart';
import 'package:app/models/loading_indicator_model.dart';
import 'package:app/shared/utilities/device_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:rxdart/rxdart.dart';

class DemoBloc extends BlocBase {
  static const screenshotChannel =
      MethodChannel('samples.flutter.dev/screenshot');

  final globalKey = GlobalKey();

  final dartCapturedImageBehaviorSubject = BehaviorSubject<Image>();
  final swiftCapturedImageBehaviorSubject = BehaviorSubject<Image>();
  final showLoadingIndicatorBehaviorSubject =
      BehaviorSubject.seeded(LoadingIndicatorModel.hide());
  final durationBehaviorSubject = BehaviorSubject<Duration>();

  @override
  dispose() {
    showLoadingIndicatorBehaviorSubject.close();
    dartCapturedImageBehaviorSubject.close();
    swiftCapturedImageBehaviorSubject.close();
    durationBehaviorSubject.close();
    super.dispose();
  }

  Future<void> onTapCaptureScreenWithDartButton() async {
    try {
      showLoadingIndicatorBehaviorSubject.add(LoadingIndicatorModel.show());
      final boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final startDateTime = DateTime.now();
      final image =
          await boundary.toImage(pixelRatio: DeviceUtilities.pixelRatio);
      final endDateTime = DateTime.now();
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      showLoadingIndicatorBehaviorSubject.add(LoadingIndicatorModel.hide());
      if (byteData == null) return;
      dartCapturedImageBehaviorSubject.add(
        Image.memory(
          byteData.buffer.asUint8List(),
          fit: BoxFit.contain,
        ),
      );
      final differenceDuration = endDateTime.difference(startDateTime);
      durationBehaviorSubject.add(differenceDuration);
    } catch (e) {
      print(e);
    }
  }

  void onTapCaptureScreenWithSwiftButton() async {
    try {
      showLoadingIndicatorBehaviorSubject.add(LoadingIndicatorModel.show());
      final startDateTime = DateTime.now();
      final result =
          await screenshotChannel.invokeMethod<String?>('captureScreen');
      final endDateTime = DateTime.now();
      showLoadingIndicatorBehaviorSubject.add(LoadingIndicatorModel.hide());
      if (result == null) return;
      swiftCapturedImageBehaviorSubject.add(Image.memory(
        _decodeBase64Image(result),
        fit: BoxFit.contain,
      ));
      final differenceDuration = endDateTime.difference(startDateTime);
      durationBehaviorSubject.add(differenceDuration);
    } on PlatformException catch (exception) {
      print(exception.message);
    }
  }

  Uint8List _decodeBase64Image(String base64String) {
    final sanitizedString = base64String.replaceAll('\n', '').replaceAll('\r', '');
    return base64Decode(sanitizedString);
  }

}
