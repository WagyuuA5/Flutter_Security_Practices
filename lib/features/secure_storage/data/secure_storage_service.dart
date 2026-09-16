import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'dummy_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'dummy_token');
  }

  Future<void> savePin(String pin) async {
    await _storage.write(key: 'dummy_pin', value: pin);
  }

  Future<String?> getPin() async {
    return await _storage.read(key: 'dummy_pin');
  }

  Future<void> clearAll() async {
    await _storage.delete(key: 'dummy_token');
    await _storage.delete(key: 'dummy_pin');
  }
}
