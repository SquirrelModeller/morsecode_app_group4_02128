import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mc_native_opencv/mc_native_opencv.dart';
import 'package:morsetorch/widgets/text_field.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final TextEditingController _textController = TextEditingController();
  double textFieldHeight = 200;

  final nativeOpencv = McNativeOpencv();

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _setupCamera();
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );
    return _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'KEEP LIGHT WITHIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  margin: const EdgeInsets.fromLTRB(40, 30, 40, 0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(width: 4, color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                ExpandableTextField(
                    controller: _textController,
                    textFieldHeight: textFieldHeight)
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          log('--> OpenCV version: ${nativeOpencv.cvVersion()}');
          nativeOpencv.initLightTracker(100);
          // print('--> OpenCV version: ${nativeOpencv.cvVersion()}');
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
