import 'package:flutter/material.dart';
import 'package:lifetrack/app/app_shell.dart';
import 'package:lifetrack/features/settings/settings_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const String root = '/';
  static const String settings = '/settings';
}

class AppRouter {
  const AppRouter._();

  static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    AppRoutes.root: (BuildContext context) => const AppShell(),
    AppRoutes.settings: (BuildContext context) => const SettingsPage(),
  };
}
