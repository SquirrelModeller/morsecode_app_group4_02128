import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mc_native_opencv_platform_interface.dart';

/// An implementation of [McNativeOpencvPlatform] that uses method channels.
class MethodChannelMcNativeOpencv extends McNativeOpencvPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mc_native_opencv');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
