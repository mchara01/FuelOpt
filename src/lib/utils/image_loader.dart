import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

Future<ui.Image> getImageFromPath(String imagePath) async {
  final ByteData imageFile = await rootBundle.load(imagePath);
  final Uint8List imageBytes = imageFile.buffer.asUint8List();

  final Completer<ui.Image> completer = Completer<ui.Image>();

  ui.decodeImageFromList(imageBytes, (ui.Image img) {
    return completer.complete(img);
  });

  return completer.future;
}