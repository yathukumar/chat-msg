#include "include/project/project_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "project_plugin.h"

void ProjectPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  project::ProjectPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
