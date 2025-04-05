import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> createCustomMarkerIcon(
  IconData iconData,
  Color color,
  double size,
) async {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(recorder);
  final TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);

  textPainter.text = TextSpan(
    text: String.fromCharCode(iconData.codePoint),
    style: TextStyle(
      fontSize: size,
      fontFamily: iconData.fontFamily,
      color: color,
    ),
  );

  textPainter.layout();
  textPainter.paint(canvas, Offset.zero);

  final ui.Image image = await recorder.endRecording().toImage(
    textPainter.width.toInt(),
    textPainter.height.toInt(),
  );

  final ByteData? byteData = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  final Uint8List pngBytes = byteData!.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(pngBytes);
}
