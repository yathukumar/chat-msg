import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'project_method_channel.dart';

abstract class ProjectPlatform extends PlatformInterface {
  /// Constructs a ProjectPlatform.
  ProjectPlatform() : super(token: _token);

  static final Object _token = Object();

  static ProjectPlatform _instance = MethodChannelProject();

  /// The default instance of [ProjectPlatform] to use.
  ///
  /// Defaults to [MethodChannelProject].
  static ProjectPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ProjectPlatform] when
  /// they register themselves.
  static set instance(ProjectPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
