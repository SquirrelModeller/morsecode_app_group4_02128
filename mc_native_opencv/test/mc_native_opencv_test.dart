import 'package:flutter_test/flutter_test.dart';
import 'package:mc_native_opencv/mc_native_opencv.dart';
import 'package:mc_native_opencv/mc_native_opencv_platform_interface.dart';
import 'package:mc_native_opencv/mc_native_opencv_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMcNativeOpencvPlatform
    with MockPlatformInterfaceMixin
    implements McNativeOpencvPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final McNativeOpencvPlatform initialPlatform = McNativeOpencvPlatform.instance;

  test('$MethodChannelMcNativeOpencv is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMcNativeOpencv>());
  });

  test('getPlatformVersion', () async {
    McNativeOpencv mcNativeOpencvPlugin = McNativeOpencv();
    MockMcNativeOpencvPlatform fakePlatform = MockMcNativeOpencvPlatform();
    McNativeOpencvPlatform.instance = fakePlatform;

    expect(await mcNativeOpencvPlugin.getPlatformVersion(), '42');
  });
}
