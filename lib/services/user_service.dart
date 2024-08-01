import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'base_api_service.dart';

class UserService extends BaseApiService {

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // User login
  Future<void> login(String email, String password) async {
    final response = await post(
      '/login',
      {'email': email, 'password': password},
    );
    print('API Yanıtı: $response');
    String token = response['token'];
    await _storage.write(key: 'token', value: token);

  }

  // User registration
  Future<void> register(String email, String phone, String password) async {
    final response = await post(
      '/register',
      {'email': email, 'phone': phone, 'password': password},
    );
    print('API Yanıtı: $response');
  }

  // Logout user
  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}
