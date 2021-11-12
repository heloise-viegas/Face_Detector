import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:z_face_detection/FacePainter.dart';
import 'package:z_face_detection/faceAttribtes.dart';

class Home extends StatelessWidget {
  final ui.Image image;
  final List<Rect> rect;
  final FaceAttributes feelings;
  Home(
      {required this.image,
      required this.rect,
      required this.feelings}); // required this.countours

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            FittedBox(
              child: SizedBox(
                height: image.height.toDouble(),
                width: image.width.toDouble(),
                child: CustomPaint(
                  painter: FacePainter(
                    imageFile: image,
                    rect: rect,
                  ), //countours: countours
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  feelings.isSmiling == true ? 'Smiling' : 'Not Smiling',
                  style: TextStyle(color: Colors.teal[300], fontSize: 30.0),
                ),
                Text(
                  feelings.isLeyeOpen == true ? 'L open' : 'L Closed',
                  style: TextStyle(color: Colors.teal[300], fontSize: 30.0),
                ),
                Text(
                  feelings.isReyeOpen == true ? 'R open' : 'R Closed',
                  style: TextStyle(color: Colors.teal[300], fontSize: 30.0),
                ),
              ],
            ),
          ],
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
