import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_test_kanban/data/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalStorageService', () {
    setUp(() async {
      // Set up shared preferences mock data
      SharedPreferences.setMockInitialValues({});
      await LocalStorageService.init();
    });

    test('setString and getString work correctly', () async {
      const key = 'test_string';
      const value = 'test_value';

      await LocalStorageService.setString(key, value);
      expect(LocalStorageService.getString(key), equals(value));
    });

    test('setInt and getInt work correctly', () async {
      const key = 'test_int';
      const value = 42;

      await LocalStorageService.setInt(key, value);
      expect(LocalStorageService.getInt(key), equals(value));
    });

    test('setListMap and getListMap work correctly', () async {
      const key = 'test_list_map';
      final value = [
        {'id': 1, 'name': 'Test 1'},
        {'id': 2, 'name': 'Test 2'},
      ];

      await LocalStorageService.setListMap(key, value);
      expect(LocalStorageService.getListMap(key), equals(value));
    });

    test('remove works correctly', () async {
      const key = 'test_remove';
      const value = 'test_value';

      await LocalStorageService.setString(key, value);
      expect(LocalStorageService.getString(key), equals(value));

      await LocalStorageService.remove(key);
      expect(LocalStorageService.getString(key), isNull);
    });

    test('clear removes all values', () async {
      await LocalStorageService.setString('key1', 'value1');
      await LocalStorageService.setInt('key2', 42);

      expect(LocalStorageService.getString('key1'), equals('value1'));
      expect(LocalStorageService.getInt('key2'), equals(42));

      await LocalStorageService.clear();

      expect(LocalStorageService.getString('key1'), isNull);
      expect(LocalStorageService.getInt('key2'), isNull);
    });

    test('containsKey returns correct value', () async {
      const key = 'test_contains';
      const value = 'test_value';

      expect(LocalStorageService.containsKey(key), isFalse);

      await LocalStorageService.setString(key, value);
      expect(LocalStorageService.containsKey(key), isTrue);
    });

    test('getListMap returns null for non-existent key', () {
      const key = 'non_existent_key';
      expect(LocalStorageService.getListMap(key), isNull);
    });
  });
}
