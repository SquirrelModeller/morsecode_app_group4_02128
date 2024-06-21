import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

// Used information from https://github.com/ValYouW/flutter-opencv-stream-processing, author ValYouW, for exposing function to Flutter/Dart.
// Written/Modified by William Pii Jæger

final DynamicLibrary nativeLib = Platform.isAndroid ? DynamicLibrary.open("libnative_opencv.so") : DynamicLibrary.process();

// C Functions Signatures
typedef _c_version = Pointer<Utf8> Function();
typedef _c_initLightTracker = Void Function(Int32 maxSize);
typedef _c_destroyLightTracker = Void Function();
typedef _c_detect = Pointer<Int64> Function(Int32 width, Int32 height, Pointer<Uint8> bytes, Int64 timestamp, Pointer<Int32> outCount);

// Dart functions signatures
typedef _dart_version = Pointer<Utf8> Function();
typedef _dart_initLightTracker = void Function(int maxSize);
typedef _dart_destroyLightTracker = void Function();
typedef _dart_detect = Pointer<Int64> Function(int width, int height, Pointer<Uint8> bytes, int timestamp, Pointer<Int32> outCount);

// Create dart functions that invoke the C funcion
final _version = nativeLib.lookupFunction<_c_version, _dart_version>('version');
final _initLightTracker = nativeLib.lookupFunction<_c_initLightTracker, _dart_initLightTracker>('initLightTracker');
final _destroyLightTracker = nativeLib.lookupFunction<_c_destroyLightTracker, _dart_destroyLightTracker>('destroyLightTracker');
final _detect = nativeLib.lookupFunction<_c_detect, _dart_detect>('detect');

class McNativeOpencv {
  static const MethodChannel _channel = MethodChannel('mc_native_opencv');
  Pointer<Uint8>? _imageBuffer;

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  String cvVersion() {
    return _version().toDartString();
  }

  void initLightTracker(int maxSize) {
    _initLightTracker(maxSize);
  }

  void destoy() {
    _destroyLightTracker();
    if (_imageBuffer != null) {
      malloc.free(_imageBuffer!);
    }
  }

  Int64List detect(int width, int height, int timeStamp, Uint8List yBuffer, Uint8List? uBuffer, Uint8List? vBuffer) {
    var ySize = yBuffer.lengthInBytes;
    var uSize = uBuffer?.lengthInBytes ?? 0;
    var vSize = vBuffer?.lengthInBytes ?? 0;
    var totalSize = ySize + uSize + vSize;

    _imageBuffer ??= malloc.allocate<Uint8>(totalSize);

    Uint8List _bytes = _imageBuffer!.asTypedList(totalSize);
    _bytes.setAll(0, yBuffer);

    if (Platform.isAndroid) {
      _bytes.setAll(ySize, vBuffer!);
      _bytes.setAll(ySize + vSize, uBuffer!);
    }

    Pointer<Int32> outCount = malloc.allocate<Int32>(1);

    var res = _detect(width, height, _imageBuffer!, timeStamp, outCount);

    final count = outCount.value;

    malloc.free(outCount);
    
    return res.asTypedList(count);
  }
}

