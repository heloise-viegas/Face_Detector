import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:z_face_detection/FacePainter.dart';

class Home extends StatelessWidget {
  final ui.Image image;
  final List<Rect> rect;
  Home({required this.image, required this.rect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FittedBox(
          child: SizedBox(
            height: image.height.toDouble(),
            width: image.width.toDouble(),
            child: CustomPaint(
              painter: FacePainter(imageFile: image, rect: rect),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Get Image'),
      ),
    );
  }
}
