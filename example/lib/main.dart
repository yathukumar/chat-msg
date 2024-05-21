import 'package:chatapp/chat.dart';
import 'package:chatapp/shared/repositories/isar_db.dart';
import 'package:chatapp/shared/utils/shared_pref.dart';
import 'package:chatapp/shared/utils/storage_paths.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'error_widget.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPref.init();
  await IsarDb.init();
  await DeviceStorage.init();
  ErrorWidget.builder = (details) => CustomErrorWidget(details: details);
  return runApp(
    const ProviderScope(
      child: ChatApp(),
    ),
  );
}

