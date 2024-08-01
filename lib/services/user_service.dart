import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'base_api_service.dart';

class UserService extends BaseApiService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // User login
  Future<void> login(String email, String password) async {
    final response = await post(
      'login',
      {
        'email': email,
        'password': password,
      },
    );

    if (response.containsKey('token')) {
      String token = response['token'];

      // Save the token to secure storage
      await _storage.write(key: 'token', value: token);
    } else {
      throw Exception('Failed to login');
    }
  }

  // User registration
  Future<void> register(String email, String phone, String password) async {
    final response = await post(
      'register',
      {
        'email': email,
        'phone': phone,
        'password': password,
      },
    );

    if (response.containsKey('message') && response['message'] == 'Registration successful') {
      print('Registration successful');
    } else {
      throw Exception('Failed to register');
    }
  }

  // Logout user
  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}
