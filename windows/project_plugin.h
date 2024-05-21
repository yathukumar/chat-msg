#ifndef FLUTTER_PLUGIN_PROJECT_PLUGIN_H_
#define FLUTTER_PLUGIN_PROJECT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace project {

class ProjectPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ProjectPlugin();

  virtual ~ProjectPlugin();

  // Disallow copy and assign.
  ProjectPlugin(const ProjectPlugin&) = delete;
  ProjectPlugin& operator=(const ProjectPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace project

#endif  // FLUTTER_PLUGIN_PROJECT_PLUGIN_H_
