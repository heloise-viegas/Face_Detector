import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:z_face_detection/faceAttribtes.dart';

import 'Home.dart';

class FaceDetectorScreen extends StatefulWidget {
  @override
  _FaceDetectorScreenState createState() => _FaceDetectorScreenState();
}

class _FaceDetectorScreenState extends State<FaceDetectorScreen> {
  late ui.Image _image;
  late List<Face> _faces;
  late List<Rect> _rect = [];
  late FaceAttributes _faceAttributes = FaceAttributes();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: onSelectImage,
        child: Center(
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.teal[50],
            ),
            child: Padding(
              padding: const EdgeInsets.all(100.0),
              child: Text(
                'Click to capture Image',
                style: TextStyle(color: Colors.teal[300], fontSize: 60.0),
              ),
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.image),
      //   onPressed: onSelectImage,
      // ),
    );
  }

  void onSelectImage() async {
    _rect.clear(); //so that previous face coordinates are cleared
    //select image from source
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.camera);
    //convert PickedImage to Image file
    final imageFile = File(pickedImage!.path);
    //process image in a form that ml uses
    final inputImage = InputImage.fromFile(imageFile);
    //convert image for custom paint function
    _loadImage(imageFile);
    //instance of FaceDetector
    final FaceDetector faceDetector = Vision.instance.faceDetector(
      FaceDetectorOptions(
        enableLandmarks: true,
        mode: FaceDetectorMode.accurate,
        enableContours: true,
        enableClassification: true,
      ),
    );
    //identify the faces in the image
    final face = await faceDetector.processImage(inputImage);

    if (mounted) {
      setState(() {
        _faces = face;
      });
    }
//get rect values for each face in the image
    for (Face detectedFace in _faces) {
      // print("Face:");
      // print(detectedFace.smilingProbability);
      faceCoordinates(detectedFace);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            image: _image,
            rect: _rect,
            feelings: _faceAttributes,
            //  countours: faceCountour,
          ),
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
    if (face.smilingProbability != null && face.smilingProbability! > 0.7) {
      print('smile:${face.smilingProbability}');
      _faceAttributes.isSmiling = true;
    } else {
      _faceAttributes.isSmiling = false;
    }
    if (face.leftEyeOpenProbability != null &&
        face.leftEyeOpenProbability! > 0.7) {
      print('leftEyeOpenProbability:${face.leftEyeOpenProbability}');
      _faceAttributes.isLeyeOpen = true;
    } else {
      _faceAttributes.isLeyeOpen = false;
    }
    if (face.rightEyeOpenProbability != null &&
        face.rightEyeOpenProbability! > 0.7) {
      print('rightEyeOpenProbability:${face.rightEyeOpenProbability}');
      _faceAttributes.isReyeOpen = true;
    } else {
      _faceAttributes.isReyeOpen = false;
    }
    // faceCountour =
    //     face.getContour(FaceContourType.face)!.positionsList.toList();
  }
}
