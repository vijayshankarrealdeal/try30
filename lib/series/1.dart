// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:tflite/tflite.dart';

// class MYAPPBASED extends StatefulWidget {
//   @override
//   _MYAPPBASEDState createState() => _MYAPPBASEDState();
// }

// class _MYAPPBASEDState extends State<MYAPPBASED> {
//   List<CameraDescription> cameras;
//   List _recognitions;
//   double _imageHeight;
//   double _imageWidth;
//   CameraImage img;
//   CameraController controller;
//   bool isBusy = false;
//   String result = '';
//   bool selection = false;

//   @override
//   void initState() {
//     loadModel();
//     initCamera();

//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.stopImageStream();
//     Tflite.close();
//     super.dispose();
//   }

//   Future loadModel() async {
//     Tflite.close();
//     try {
//       String res;
//       res = await Tflite.loadModel(model: "assets/converted_model.tflite");
//       print(res);
//     } on PlatformException {
//       print('Failed To Load');
//     }
//   }

//   List<Widget> renderKeyPoints(Size screen) {
//     if (_recognitions == null) return [];
//     if (_imageHeight == null || _imageWidth == null) return [];
//     double factorX = screen.width;
//     double factorY = _imageHeight;

//     var lists = <Widget>[];
//     _recognitions.forEach((re) {
//       var list = re["keypoinst"].values.map((k) {
//         return Positioned(
//             left: k["x"] * factorX - 6,
//             top: k["y"] * factorX - 6,
//             child: Text(
//               "${k["part"]}",
//               style: TextStyle(color: Colors.green),
//             ));
//       }).toList();
//       lists..addAll(list);
//     });
//     return lists;
//   }

//   initCamera() {
//     controller = CameraController(cameras[0], ResolutionPreset.medium);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {
//         controller.startImageStream((image) => {
//               if (!isBusy) {isBusy = true, img = image, runModelOnFrame()}
//             });
//       });
//     });
//   }

//   runModelOnFrame() async {
//     _imageWidth = img.width + 0.0;
//     _imageHeight = img.height + 0.0;
//     _recognitions = await Tflite.runPoseNetOnFrame(
//       bytesList: img.planes.map((plane) {
//         return plane.bytes;
//       }).toList(),
//       imageHeight: img.height,
//       imageWidth: img.width,
//       numResults: 2,
//     );
//     isBusy = false;
//     setState(() {
//       img;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     List<Widget> stackChildren = [];
//     stackChildren.add(Positioned(
//         top: 0.0,
//         left: 0.0,
//         width: size.width,
//         child: Container(
//           child: (!controller.value.isInitialized)
//               ? Container()
//               : AspectRatio(
//                   aspectRatio: controller.value.aspectRatio,
//                   child: CameraPreview(controller),
//                 ),
//         )));
//     if (img != null) {
//       stackChildren.addAll(renderKeyPoints(size));
//     }
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           child: Stack(
//             children: stackChildren,
//           ),
//         ),
//       ),
//     );
//   }
// }
