import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:morsetorch/services/morse_detection_async.dart';
import 'package:morsetorch/services/morse_translator.dart';

// Written by ValYouW https://github.com/ValYouW/flutter-opencv-stream-processing
// Edited by William Pii Jæger, modified to support our needs for our data streaming/processing

class MorseDetection extends StatefulWidget {
  const MorseDetection({Key? key}) : super(key: key);

  @override
  MorseDetectionPageState createState() => MorseDetectionPageState();
}

class MorseDetectionPageState extends State<MorseDetection>
    with WidgetsBindingObserver {
  CameraController? _camController;
  late MorseDetectionAsync _lightDetector;
  Morsetranslator translate = Morsetranslator();

  int _lastRun = 0;
  int timeStamp = 0;
  bool _detectionInProgress = false;

  bool recievedFirstPackage = false;

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
    var idx =
        cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.back);
    if (idx < 0) {
      log("No back camera found");
      return;
    }

    var desc = cameras[idx];
    _camController = CameraController(
      desc,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.yuv420
          : ImageFormatGroup.bgra8888,
    );
    try {
      await _camController!.initialize();
      await _camController!
          .startImageStream((image) => _processCameraImage(image, DateTime.now().millisecondsSinceEpoch));
    } catch (e) {
      log("Error initializing camera, error: ${e.toString()}");
    }
    if (mounted) {
      setState(() {});
    }
  }

  int previousTime = 0;
  void _processCameraImage(CameraImage image, int time) async {
    if (_detectionInProgress ||
        !mounted ||
        DateTime.now().millisecondsSinceEpoch - _lastRun < 10) {
      return;
    }

    // Call the detector
    _detectionInProgress = true;
    var res = await _lightDetector.detect(
        image, time);
    _detectionInProgress = false;
    _lastRun = DateTime.now().millisecondsSinceEpoch;

    if (!mounted || res == null) {
      return;
    }

    if (res.isNotEmpty) {
      translate.addPackageToList(res);
      try {
        log(translate.returnText());
        log(translate.calculateTimeUnit().toString());
      } on Exception catch (e) {}
      //for (int i = 0; i < res.length; i += 2) {
       //log("${res[i] == 1}, ${res[i + 1]}, timeDiff: ${res[i+1]-previousTime}");
       //previousTime = res[i+1];
      //}
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
