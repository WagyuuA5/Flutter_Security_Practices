import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_security_practices/features/secure_storage/data/secure_storage_service.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late SecureStorageService service;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    service = SecureStorageService(mockStorage);
  });

  test('saveToken writes dummy_token to storage', () async {
    when(() => mockStorage.write(key: 'dummy_token', value: 'my_token'))
        .thenAnswer((_) async {});

    await service.saveToken('my_token');

    verify(() => mockStorage.write(key: 'dummy_token', value: 'my_token')).called(1);
  });

  test('getToken reads dummy_token from storage', () async {
    when(() => mockStorage.read(key: 'dummy_token'))
        .thenAnswer((_) async => 'my_token');

    final token = await service.getToken();

    expect(token, 'my_token');
    verify(() => mockStorage.read(key: 'dummy_token')).called(1);
  });

  test('savePin writes dummy_pin to storage', () async {
    when(() => mockStorage.write(key: 'dummy_pin', value: '1234'))
        .thenAnswer((_) async {});

    await service.savePin('1234');

    verify(() => mockStorage.write(key: 'dummy_pin', value: '1234')).called(1);
  });

  test('clearAll deletes token and pin', () async {
    when(() => mockStorage.delete(key: 'dummy_token')).thenAnswer((_) async {});
    when(() => mockStorage.delete(key: 'dummy_pin')).thenAnswer((_) async {});

    await service.clearAll();

    verify(() => mockStorage.delete(key: 'dummy_token')).called(1);
    verify(() => mockStorage.delete(key: 'dummy_pin')).called(1);
  });
}
