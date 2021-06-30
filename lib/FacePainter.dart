import 'dart:ui';

import 'package:flutter/material.dart';

class FacePainter extends CustomPainter {
  var imageFile;
  late List<Rect> rect;
  // late List<Offset> countours;
  FacePainter({
    required this.imageFile,
    required this.rect,
  }); // required this.countours

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    for (Rect rectangle in rect) {
      canvas.drawRect(
        rectangle,
        Paint()
          ..color = Colors.teal
          ..strokeWidth = 7.0
          ..style = PaintingStyle.stroke,
      );
    }

    // final lipPaint = Paint()
    //   ..strokeWidth = 3.0
    //   ..color = Colors.pink;
    //
    // canvas.drawPoints(PointMode.polygon, countours, lipPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
