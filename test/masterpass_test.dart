import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterpass/masterpass.dart';

void main() {
  const MethodChannel channel = MethodChannel('masterpass');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Masterpass.platformVersion, '42');
  });
}
