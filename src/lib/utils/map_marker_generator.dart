import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'image_loader.dart';

Future<BitmapDescriptor> createFuelStationIcon(String imagePath, Color backgroundColor) async {
  double degToRad(double deg) => deg * (pi / 180.0);

  const Size size = Size(140, 170);

  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();

  final Canvas canvas = Canvas(pictureRecorder);

  final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

  final Path circlePath = Path();
  circlePath.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2), radius: 60));

  final Path anchorPath = Path();
  anchorPath.addPolygon(<Offset>[
    Offset((size.width / 2) - 60*sin(degToRad(20)), (size.height / 2) + 60*cos(degToRad(20))),
    Offset(size.width / 2, size.height - 5),
    Offset((size.width / 2) + 60*sin(degToRad(20)), (size.height / 2) + 60*cos(degToRad(20)))
  ], true);

  Paint whitePathPaint = Paint();
  whitePathPaint.color = Colors.white;
  whitePathPaint.style = PaintingStyle.stroke;
  whitePathPaint.strokeWidth = 8.0;

  canvas.drawRect(rect, Paint()..color = Colors.transparent);

  canvas.drawShadow(circlePath, Colors.grey, 3.0, false);

  canvas.drawPath(circlePath, Paint()..color = backgroundColor);
  
  canvas.drawPath(circlePath, whitePathPaint);

  canvas.drawShadow(anchorPath, Colors.grey, 3.0, false);

  canvas.drawPath(anchorPath, Paint()..color = Colors.white);



  final Rect oval = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2), radius: 50);

  // Add path for oval image
  canvas.clipPath(Path()..addOval(oval));

  final ui.Image image = await getImageFromPath(imagePath);
  paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

  // Convert canvas to image
  final ui.Image markerAsImage = await pictureRecorder
      .endRecording()
      .toImage(size.width.toInt(), size.height.toInt());

  // Convert image to bytes
  final ByteData? byteData =
  await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List uint8List = byteData!.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(uint8List);
}