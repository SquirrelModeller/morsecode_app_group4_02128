import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:morsetorch/services/morse_detection_async.dart';

// Written by ValYouW https://github.com/ValYouW/flutter-opencv-stream-processing
// Edited by William Pii Jæger, modified to support our needs for our data streaming/processing

class MorseDetection extends StatefulWidget {
  const MorseDetection({Key? key}) : super(key: key);

  @override
  _MorseDetectionPageState createState() => _MorseDetectionPageState();
}

class _MorseDetectionPageState extends State<MorseDetection> with WidgetsBindingObserver {
  CameraController? _camController;
  late MorseDetectionAsync _lightDetector;
  int _lastRun = 0;
  int timeStamp = 0;
  bool _detectionInProgress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _lightDetector = MorseDetectionAsync();
    initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _camController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _lightDetector.destroy();
    _camController?.dispose();
    super.dispose();
  }

Future<void> initCamera() async {
    final cameras = await availableCameras();
    var idx = cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.back);
    if (idx < 0) {
      log("No back camera found");
      return;
    }

    var desc = cameras[idx];
    _camController = CameraController(
      desc,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.yuv420 : ImageFormatGroup.bgra8888,
    );
    try {
      await _camController!.initialize();
      await _camController!.startImageStream((image) => _processCameraImage(image));
    } catch (e) {
      log("Error initializing camera, error: ${e.toString()}");
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (_detectionInProgress || !mounted || DateTime.now().millisecondsSinceEpoch - _lastRun < 30) {
      return;
    }

    // Call the detector
    _detectionInProgress = true;
    var res = await _lightDetector.detect(image, DateTime.now().millisecondsSinceEpoch);
    _detectionInProgress = false;
    _lastRun = DateTime.now().millisecondsSinceEpoch;
    

    if (!mounted || res == null) {
      return;
    }

    if (res.isNotEmpty) {
      log("Package");
      for (var elm in res) {
        log(elm.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_camController == null) {
      return const Center(
        child: Text('Loading...'),
      );
    }

    return Stack(
      children: [
        CameraPreview(_camController!),
      ],
    );
  }
}

