import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'base_api_service.dart';

class UserService extends BaseApiService {

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // User login
  Future<void> login(String email, String password) async {

    try {
      final response = await post('/login', {
        'email': email,
        'password': password,
      });

      // Yanıtın içeriğini kontrol et
      if (response['statusCode'] == 200) {
        // Giriş başarılı
        //String token = response['token'];
        //await _storage.write(key: 'token', value: token);
        return;
      } else {
        // Hata mesajını yanıt gövdesinden al
        throw Exception('Failed to login: ${response['body']}');
      }
    } catch (e) {
      print('UserService login hata: $e');
      throw Exception('Giriş başarısız: $e');
    }

  }

  // User registration
  Future<void> register(String email, String phone, String password) async {
    try {
      final response = await post('/register', {
        'email': email,
        'phone': phone,
        'password': password,
      });

      // Yanıtın içeriğini kontrol et
      if (response['statusCode'] == 201) {
        // Kayıt başarılı
        return;
      } else {
        // Hata mesajını yanıt gövdesinden al
        throw Exception('Failed to register: ${response['body']}');
      }
    } catch (e) {
      print('UserService register hata: $e');
      throw Exception('Kayıt başarısız: $e');
    }
  }

  Future<void> registerNewUser(String email, String phone, String password, String adminId) async {
    try {
      final response = await post('/registerNewUser', {
        'email': email,
        'phone': phone,
        'password': password,
        'adminId': adminId,
      });

      // Yanıtın içeriğini kontrol et
      if (response['statusCode'] == 201) {
        // Kayıt başarılı
        return;
      } else {
        // Hata mesajını yanıt gövdesinden al
        throw Exception('Failed to register: ${response['body']}');
      }
    } catch (e) {
      print('UserService register hata: $e');
      throw Exception('Kayıt başarısız: $e');
    }
  }


  // Logout user
  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}
