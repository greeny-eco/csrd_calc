import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterUtils on WidgetTester {
  Future<void> takeScreenshot({required String name}) async {
    final liveElement = binding.rootElement!;

    late final Uint8List bytes;
    await binding.runAsync(() async {
      final image = await _captureImage(liveElement);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        return 'Could not take screenshot';
      }
      bytes = byteData.buffer.asUint8List();
      image.dispose();
    });

    final directory = Directory('./screenshots');
    if (!directory.existsSync()) {
      directory.createSync();
    }
    final file = File('./screenshots/$name.png');
    file.writeAsBytesSync(bytes);
  }

  Future<ui.Image> _captureImage(Element element) async {
    assert(element.renderObject != null);
    RenderObject renderObject = element.renderObject!;
    while (!renderObject.isRepaintBoundary) {
      // ignore: unnecessary_cast
      renderObject = renderObject.parent! as RenderObject;
    }
    assert(!renderObject.debugNeedsPaint);

    final OffsetLayer layer = renderObject.debugLayer! as OffsetLayer;
    final ui.Image image = await layer.toImage(renderObject.paintBounds);

    if (element.renderObject is RenderBox) {
      final expectedSize = (element.renderObject as RenderBox?)!.size;
      if (expectedSize.width != image.width ||
          expectedSize.height != image.height) {
        // ignore: avoid_print
        print(
          'Warning: The screenshot captured of ${element.toStringShort()} is '
          'larger (${image.width}, ${image.height}) than '
          '${element.toStringShort()} (${expectedSize.width}, ${expectedSize.height}) itself.\n'
          'Wrap the ${element.toStringShort()} in a RepaintBoundary to be able to capture only that layer. ',
        );
      }
    }

    return image;
  }
}
