import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mc_native_opencv/mc_native_opencv_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMcNativeOpencv platform = MethodChannelMcNativeOpencv();
  const MethodChannel channel = MethodChannel('mc_native_opencv');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
