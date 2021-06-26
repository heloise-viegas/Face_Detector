import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

import 'Home.dart';

class FaceDetectorScreen extends StatefulWidget {
  @override
  _FaceDetectorScreenState createState() => _FaceDetectorScreenState();
}

class _FaceDetectorScreenState extends State<FaceDetectorScreen> {
  late ui.Image _image;
  late List<Face> _faces;
  late List<Rect> _rect = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: FittedBox(
      //   child: SizedBox(
      //     height: _image.height.toDouble(),
      //     width: _image.width.toDouble(),
      //     child: CustomPaint(
      //       painter: FacePainter(imageFile: _image, rect: rect),
      //     ),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.image),
        onPressed: onSelectImage,
      ),
    );
  }

  void onSelectImage() async {
    _rect.clear(); //so that previous face coordinates are cleared
    //select image from source
    final imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    //convert PickedImage to Image file
    final imagePath = File(imageFile!.path);
    //process image in a form that ml uses
    final image = InputImage.fromFile(imagePath);
    //convert image for custom paint function
    _loadImage(imagePath);
    //instance of FaceDetector
    final FaceDetector faceDetector = Vision.instance.faceDetector(
      FaceDetectorOptions(
        enableLandmarks: true,
        mode: FaceDetectorMode.accurate,
      ),
    );
    //identify the faces in the image
    final face = await faceDetector.processImage(image);
    if (mounted) {
      setState(() {
        _faces = face;
      });
    }
//get rect values for each face in the image
    for (Face detectedFace in _faces) {
      faceCoordinates(detectedFace);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(image: _image, rect: _rect),
        ));
  }

  void _loadImage(File file) async {
    //converts selected image to a format that custom painters drawImage can use
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
      (value) => setState(() {
        _image = value;
      }),
    );
  }

  void faceCoordinates(Face face) {
    //  final pos = face.boundingBox;
    _rect.add(face.boundingBox);
  }
}
