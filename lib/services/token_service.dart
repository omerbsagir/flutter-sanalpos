import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Save token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  // Retrieve token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Delete token
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }
}
