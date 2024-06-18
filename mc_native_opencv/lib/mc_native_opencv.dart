
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';


final DynamicLibrary nativeLib = Platform.isAndroid ? DynamicLibrary.open("libnative_opencv.so") : DynamicLibrary.process();

// C Functions Signatures
typedef _c_version = Pointer<Utf8> Function();
typedef _c_initLightTracker = Void Function(Int32 maxSize);
typedef _c_updateLights = Pointer<MorseSignal> Function(Pointer<Uint8> bytes, Int32 width, Int32 height, Int64 timestamp);

// Dart functions signatures
typedef _dart_version = Pointer<Utf8> Function();
typedef _dart_initLightTracker = void Function(int maxSize);
typedef _dart_updateLights = Pointer<MorseSignal> Function(Pointer<Uint8> bytes, int width, int height, int timestamp);
typedef _c_freeMemory = Void Function(Pointer<Void>);
typedef _dart_freeMemory = void Function(Pointer<Void>);

final _freeMemory = nativeLib.lookupFunction<_c_freeMemory, _dart_freeMemory>('freeMemory');



// MorseSignal in Dart
final class MorseSignal extends Struct {
  @Bool()
  external bool isOn;

  @Int64()
  external int timestamp;
}

final class MorseSignalResult extends Struct {
  @Int32()
  external int count;

  // Pointer<MorseSignal> get signals => addressOf.cast<MorseSignal>();
}


// Create dart functions that invoke the C funcion
final _version = nativeLib.lookupFunction<_c_version, _dart_version>('version');
final _initLightTracker = nativeLib.lookupFunction<_c_initLightTracker, _dart_initLightTracker>('initLightTracker');
final _updateLights = nativeLib.lookupFunction<_c_updateLights, _dart_updateLights>('updateLights');

// final _testfunction = nativeLib.lookupFunction<bool>('test');

class McNativeOpencv {
  static const MethodChannel _channel = MethodChannel('mc_native_opencv');

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

  // Dart function to free a pointer to MorseSignal
  void freeMorseSignals(Pointer<MorseSignal> ptr) {
      _freeMemory(ptr.cast<Void>());
  }

  // List<MorseSignal> updateLights(Uint8List byteData, int width, int height, int timestamp) {
  //   final bytesPointer = malloc.allocate<Uint8>(byteData.length);
  //   bytesPointer.asTypedList(byteData.length).setAll(0, byteData);

    // Pointer<MorseSignalResult> result = _updateLights(bytesPointer, width, height, timestamp);
    // int count = result.ref.count;

    // List<MorseSignal> signals = List.generate(count, (i) {
    //   return result.ref.signals.elementAt(i).ref;
    // });

    // // Freeing the memory
    // _freeMemory(result.cast<Void>());
    // malloc.free(bytesPointer);

    // return signals;
// }
// final _freeMemory = nativeLib.lookupFunction<_c_freeMemory, _dart_freeMemory>('freeMemory');
}

