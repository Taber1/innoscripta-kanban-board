// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:innoscripta_test_kanban/main.dart';
import 'package:innoscripta_test_kanban/data/services/local_storage_service.dart';
import 'package:get_it/get_it.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Setup SharedPreferences for testing
    SharedPreferences.setMockInitialValues({
      'theme_mode': 'system',
      // Add other necessary mock values
    });

    // Register LocalStorageService with GetIt
    final getIt = GetIt.instance;
    if (!getIt.isRegistered<LocalStorageService>()) {
      getIt.registerSingleton<LocalStorageService>(LocalStorageService());
    }

    // Initialize LocalStorageService
    await LocalStorageService.init();
  });

  tearDown(() {
    // Clean up GetIt registrations
    final getIt = GetIt.instance;
    if (getIt.isRegistered<LocalStorageService>()) {
      getIt.unregister<LocalStorageService>();
    }
  });

  testWidgets('App initialization test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(); // Wait for all animations to complete

    // Add your widget tests here
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
