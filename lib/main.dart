import 'dart:io';
import 'package:drowsiness_detector/camera_scree.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:camera/camera.dart';

List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage(), routes: {
      CameraScreen.routename: (context) => CameraScreen(cameras),
    });
  }
}

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  HomePage({this.cameras});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void launchPhone(command) async {
    if (await UrlLauncher.canLaunch(command)) {
      await UrlLauncher.launch(command);
    } else
      print('Could not launch $command');
  }

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color(0xff32B8BB),
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            child: Center(
              child: _image != null
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.8,
                      color: Colors.black,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Text(
                      'Drowsiness Detector',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          // /* Positioned(
          //   child: CircleAvatar(
          //     radius: 1000,
          //     backgroundColor: Color.fromRGBO(31, 63, 88, 0.2),
          //     child: Container(),
          //   ),
          //   right: -1920,
          //   top: -500,
          // ), */
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(CameraScreen.routename);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color(0xff32B8BB),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 5)
                        ]),
                    height: width * 0.3,
                    width: width * 0.45,
                    child: Center(
                      child: Text(
                        'Live Camera',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: getImage,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color(0xff32B8BB),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 5)
                        ]),
                    height: width * 0.3,
                    width: width * 0.45,
                    child: Center(
                      child: Text(
                        'Capture Image',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Center(
                    child: Icon(Icons.emoji_food_beverage),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff32B8BB),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 5)
                      ]),
                  height: width * 0.2,
                  width: width * 0.2,
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => launchPhone('tel: 8765247103'),
                  child: Container(
                    child: Center(
                      child: Icon(Icons.phone),
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff32B8BB),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 5)
                        ]),
                    height: width * 0.2,
                    width: width * 0.2,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Center(
                    child: Icon(Icons.location_on),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff32B8BB),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 5)
                      ]),
                  height: width * 0.2,
                  width: width * 0.2,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
