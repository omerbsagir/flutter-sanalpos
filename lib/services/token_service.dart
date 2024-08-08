import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';


class TokenService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();


  Future<bool> checkToken() async {
    final token = await _storage.read(key: 'token');
    return token != null;
  }


  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }


  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }


  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('Invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64Url string!');
    }
    return utf8.decode(base64Url.decode(output));
  }
}
