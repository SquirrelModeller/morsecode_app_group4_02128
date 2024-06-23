import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:morsetorch/services/light_detector_service.dart' as ld;

// Written by ValYouW https://github.com/ValYouW/flutter-opencv-stream-processing
// Edited by William Pii Jæger, modified to support our needs for our data streaming/processing

class MorseDetectionAsync {
  bool arThreadReady = false;
  late Isolate _detectorThread;
  late SendPort _toDetectorThread;
  int _reqId = 0;
  final Map<int, Completer> _cbs = {};

  MorseDetectionAsync() {
    _initDetectionThread();
  }

  void _initDetectionThread() async {
    // Create the port on which the detector thread will send us messages and listen to it.
    ReceivePort fromDetectorThread = ReceivePort();
    fromDetectorThread.listen(_handleMessage, onDone: () {
      arThreadReady = false;
    });

    final initReq = ld.InitRequest(toMainThread: fromDetectorThread.sendPort);
    _detectorThread = await Isolate.spawn(ld.init, initReq);
  }

  Future<Int64List?> detect(CameraImage image, int timeStamp) {
    if (!arThreadReady) {
      return Future.value(null);
    }
    var reqId = ++_reqId;
    var res = Completer<Int64List?>();
    _cbs[reqId] = res;
    var msg = ld.Request(
      reqId: reqId,
      method: 'detect',
      params: {'image': image, 'Unix Time': timeStamp},
    );

    _toDetectorThread.send(msg);
    return res.future;
  }

  void destroy() async {
    if (!arThreadReady) {
      return;
    }

    arThreadReady = false;

    // We send a Destroy request and wait for a response before killing the thread
    var reqId = ++_reqId;
    var res = Completer();
    _cbs[reqId] = res;
    var msg = ld.Request(reqId: reqId, method: 'destroy');
    _toDetectorThread.send(msg);

    // Wait for the detector to acknoledge the destory and kill the thread
    await res.future;
    _detectorThread.kill();
  }

  void _handleMessage(data) {
    // The detector thread send us its SendPort on init, if we got it this meand the detector is ready
    if (data is SendPort) {
      _toDetectorThread = data;
      arThreadReady = true;
      return;
    }

    // Make sure we got a Response object
    if (data is ld.Response) {
      // Find the Completer associated with this request and resolve it
      var reqId = data.reqId;
      _cbs[reqId]?.complete(data.data);
      _cbs.remove(reqId);
      return;
    }

    log('Unknown message from MorseLightDetector, got: $data');
  }
}
