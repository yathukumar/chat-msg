
import 'project_platform_interface.dart';

class Project {
  Future<String?> getPlatformVersion() {
    return ProjectPlatform.instance.getPlatformVersion();
  }
}
