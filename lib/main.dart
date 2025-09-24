import 'package:brother_admin_panel/firebase_options.dart';
import 'package:brother_admin_panel/bindings/index.dart';
import 'package:brother_admin_panel/utils/keyboard_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io' show Platform;

// Web-specific imports
import 'package:image_picker/image_picker.dart';

// Desktop window management
import 'package:window_manager/window_manager.dart';
import 'package:desktop_window/desktop_window.dart';

import 'package:brother_admin_panel/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KeyboardHandler.initialize();

  if (kIsWeb) {
    usePathUrlStrategy();

    try {
      ImagePicker();
      if (kDebugMode) {
        print('✅ Image picker initialized for web');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Image picker initialization warning: $e');
      }
    }
  }

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await _initializeDesktopWindow();
  }

  await GetStorage.init();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      if (kDebugMode) {
        print('✅ Firebase initialized successfully');
        print(
          '📦 Storage Bucket: ${DefaultFirebaseOptions.currentPlatform.storageBucket}',
        );
        print(
          '🌐 Project ID: ${DefaultFirebaseOptions.currentPlatform.projectId}',
        );
      }
    } else {
      if (kDebugMode) {
        print('ℹ️ Firebase already initialized');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('❌ Firebase initialization failed: $e');
    }
  }

  GeneralBinding().dependencies();

  runApp(const App());
}

Future<void> _initializeDesktopWindow() async {
  try {
    await windowManager.ensureInitialized();

    const WindowOptions windowOptions = WindowOptions(
      size: Size(1400, 900),
      minimumSize: Size(1000, 700),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      windowButtonVisibility: true,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setTitle(
          'Brother Creative Admin Panel - لوحة تحكم Brother Creative');
    });

    await DesktopWindow.setWindowSize(const Size(1400, 900));
    await DesktopWindow.setMinWindowSize(const Size(1000, 700));
    await DesktopWindow.setMaxWindowSize(Size.infinite);

    if (kDebugMode) {
      print('✅ Desktop window initialized successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      print('⚠️ Failed to initialize desktop window: $e');
    }
  }
}
