import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'project_platform_interface.dart';

/// An implementation of [ProjectPlatform] that uses method channels.
class MethodChannelProject extends ProjectPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('project');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
