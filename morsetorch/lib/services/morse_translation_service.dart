import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:morsetorch/services/morse_detection_async.dart';
import 'package:morsetorch/services/morse_translator.dart';

// Written by ValYouW https://github.com/ValYouW/flutter-opencv-stream-processing
// Edited by William Pii Jæger, modified to be a service excluding UI, to support our needs for our data streaming/processing

class MorseTranslationService {
  CameraController? cameraController;
  final MorseDetectionAsync lightDetector = MorseDetectionAsync();
  final Morsetranslator translator = Morsetranslator();
  late Function(String) onTranslationUpdated;
  bool detectionInProgress = false;
  int lastRun = 0;

  MorseTranslationService(this.onTranslationUpdated);

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    int idx =
        cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.back);
    if (idx == -1) {
      log("No back camera found");
      return;
    }

    var cameraDescription = cameras[idx];
    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.yuv420
          : ImageFormatGroup.bgra8888,
    );

    try {
      await cameraController!.initialize();
      cameraController!.startImageStream((image) =>
          processCameraImage(image, DateTime.now().millisecondsSinceEpoch));
    } catch (e) {
      log("Error initializing camera: ${e.toString()}");
    }
  }
  var previousTime = 0;
  void processCameraImage(CameraImage image, int time) async {
    if (detectionInProgress ||
        DateTime.now().millisecondsSinceEpoch - lastRun < 2) {
      return;
    }
    detectionInProgress = true;
    var result = await lightDetector.detect(image, time);
    detectionInProgress = false;
    lastRun = DateTime.now().millisecondsSinceEpoch;

    if (result != null && result.isNotEmpty) {
      // log("Package:");
      // for (int i = 0; i < result.length; i += 2) {
      //  log("${result[i] == 1}, ${result[i + 1]}, timeDiff: ${result[i+1]-previousTime}");
      //  previousTime = result[i+1];
      // }
      translator.addPackageToList(result);
      onTranslationUpdated(translator.returnText());
    }
  }

  void dispose() {
    cameraController?.dispose();
    lightDetector.destroy();
  }
}
