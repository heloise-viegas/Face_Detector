import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:z_face_detection/Home.dart';

class FaceDetectorScreen extends StatefulWidget {
  @override
  _FaceDetectorScreenState createState() => _FaceDetectorScreenState();
}

class _FaceDetectorScreenState extends State<FaceDetectorScreen> {
  late ui.Image _image;
  late File _imageFile;
  late List<Face> _faces;
  late bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.image),
        onPressed: () async {
          // _onImageSelected();
          //select image from source
          final imageFile =
              await ImagePicker().getImage(source: ImageSource.gallery);
          //convert PickedImage to Image file
          final imagePath = File(imageFile!.path);
          //process image in a form that ml uses
          final image = InputImage.fromFile(imagePath);
          _loadImage(imagePath);
          //detect the faces
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
              _imageFile = imagePath;
              _faces = face;
            });
          }
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ImagesDetected(image: _image, faces: _faces)),
          );
        },
      ),
    );
  }

  void _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
      (value) => setState(() {
        _image = value;
        print('n');
        print(_image);
      }),
    );
  }

  void _onImageSelected() async {
    //select image from source
    final imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    //convert PickedImage to Image file
    final imagePath = File(imageFile!.path);
    //process image in a form that ml uses
    final image = InputImage.fromFile(imagePath);
    _loadImage(imagePath);
    //detect the faces
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
        _imageFile = imagePath;
        _faces = face;
      });
    }
  }
}
