import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'camera.dart';
import 'bndbox.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraScreen(this.cameras);
  static const routename = 'camera-screen';
  @override
  CameraScreenState createState() {
    return new CameraScreenState();
  }
}

class CameraScreenState extends State<CameraScreen> {
  List<dynamic> _recognitions;
  int _imgHeight = 0;
  int _imageWidth = 0;
  // ignore: unused_field
  String _model = "";
  @override
  void initState() {
    loadModel();
    super.initState();
  }

  loadModel() async {
    String res;
    res = await Tflite.loadModel(
        model: 'assets/tflite/converted_model.tflite',
        labels: 'assets/tflite/labels.txt');
    print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imgWidth) {
    setState(() {
      _recognitions = recognitions;
      _imgHeight = imageHeight;
      _imageWidth = imgWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Camera(widget.cameras, setRecognitions),
        BndBox(
            _recognitions == null ? [] : _recognitions,
            math.max(_imgHeight, _imageWidth),
            math.min(_imgHeight, _imageWidth),
            screen.height,
            screen.width)
      ],
    ));
  }
}
