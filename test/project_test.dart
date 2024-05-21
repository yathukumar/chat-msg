import 'package:flutter_test/flutter_test.dart';
import 'package:chatapp/project.dart';
import 'package:chatapp/project_platform_interface.dart';
import 'package:chatapp/project_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockProjectPlatform
    with MockPlatformInterfaceMixin
    implements ProjectPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ProjectPlatform initialPlatform = ProjectPlatform.instance;

  test('$MethodChannelProject is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelProject>());
  });

  test('getPlatformVersion', () async {
    Project projectPlugin = Project();
    MockProjectPlatform fakePlatform = MockProjectPlatform();
    ProjectPlatform.instance = fakePlatform;

    expect(await projectPlugin.getPlatformVersion(), '42');
  });
}
