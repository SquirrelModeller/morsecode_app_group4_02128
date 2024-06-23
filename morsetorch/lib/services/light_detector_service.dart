import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:mc_native_opencv/mc_native_opencv.dart';

// Written by ValYouW https://github.com/ValYouW/flutter-opencv-stream-processing
// Edited by William Pii Jæger, modified to support our needs for our data streaming/processing

class InitRequest {
  SendPort toMainThread;
  InitRequest({required this.toMainThread});
}

class Request {
  int reqId;
  String method;
  dynamic params;
  Request({required this.reqId, required this.method, this.params});
}

class Response {
  int reqId;
  dynamic data;
  Response({required this.reqId, this.data});
}

late _LightDetectorService _detector;
late SendPort _toMainThread;

void init(InitRequest initReq) {
  _detector = _LightDetectorService();

  _toMainThread = initReq.toMainThread;

  ReceivePort fromMainThread = ReceivePort();
  fromMainThread.listen(_handleMessage);

  _toMainThread.send(fromMainThread.sendPort);
}

void _handleMessage(data) {
  if (data is Request) {
    dynamic res;
    switch (data.method) {
      case 'detect':
        var image = data.params['image'] as CameraImage;
        var timeStamp = data.params['Unix Time'] as int;
        res = _detector.detect(image, timeStamp);
        break;
      case 'destroy':
        _detector.destoy();
        break;
      default:
        log("Unkown method: ${data.method}");
    }

    _toMainThread.send(Response(reqId: data.reqId, data: res));
  }
}

class _LightDetectorService {
  McNativeOpencv? _nativeOpencv;

  _LightDetectorService() {
    init();
  }

  init() async {
    _nativeOpencv = McNativeOpencv();
    _nativeOpencv!.initLightTracker(200);
  }

  Int64List? detect(CameraImage image, int timeStamp) {
    if (_nativeOpencv == null) {
      return null;
    }

    var planes = image.planes;
    var yBuffer = planes[0].bytes;

    Uint8List? uBuffer;
    Uint8List? vBuffer;

    if (Platform.isAndroid) {
      uBuffer = planes[1].bytes;
      vBuffer = planes[2].bytes;
    }

    var res = _nativeOpencv!.detect(
        image.width, image.height, timeStamp, yBuffer, uBuffer, vBuffer);
    return res;
  }

  destoy() {
    if (_nativeOpencv != null) {
      _nativeOpencv!.destoy();
      _nativeOpencv = null;
    }
  }
}
