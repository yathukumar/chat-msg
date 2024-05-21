library chat;
import 'package:chatapp/shared/utils/abc.dart';
import 'package:chatapp/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/views/welcome.dart';
import 'features/home/views/base.dart';

class ChatApp extends ConsumerWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: "Chat",
      initialRoute: '/',
      theme: ref.read(lightThemeProvider),
      darkTheme: ref.read(darkThemeProvider),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: ref.read(authRepositoryProvider).auth.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return const WelcomePage();
          }

          final user = getCurrentUser();
          if (user == null) {
            return const WelcomePage();
          }

          return HomePage(user: user);
        },
      ),
    );
  }
}

