import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:z_face_detection/FacePainter.dart';

class ImagesDetected extends StatefulWidget {
  final ui.Image image;
  final List<Face> faces;
  ImagesDetected({required this.image, required this.faces});
  final List<Rect> rect = [];
  @override
  _ImagesDetectedState createState() => _ImagesDetectedState();
}

class _ImagesDetectedState extends State<ImagesDetected> {
  @override
  void initState() {
    for (Face detectedFace in widget.faces) {
      faceCoordinates(detectedFace);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FittedBox(
        child: SizedBox(
          height: widget.image.height.toDouble(),
          width: widget.image.width.toDouble(),
          child: CustomPaint(
              painter: FacePainter(imageFile: widget.image, rect: widget.rect)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Image'),
      ),
    );
  }

  void faceCoordinates(Face face) {
    //  final pos = face.boundingBox;
    widget.rect.add(face.boundingBox);
  }
}
