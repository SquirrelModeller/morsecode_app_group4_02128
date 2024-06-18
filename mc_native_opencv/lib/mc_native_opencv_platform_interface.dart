import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mc_native_opencv_method_channel.dart';

abstract class McNativeOpencvPlatform extends PlatformInterface {
  /// Constructs a McNativeOpencvPlatform.
  McNativeOpencvPlatform() : super(token: _token);

  static final Object _token = Object();

  static McNativeOpencvPlatform _instance = MethodChannelMcNativeOpencv();

  /// The default instance of [McNativeOpencvPlatform] to use.
  ///
  /// Defaults to [MethodChannelMcNativeOpencv].
  static McNativeOpencvPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [McNativeOpencvPlatform] when
  /// they register themselves.
  static set instance(McNativeOpencvPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
