import 'dart:convert';
import 'base_api_service.dart';
import 'token_service.dart';

class UserService extends BaseApiService {

  // User login
  Future<void> login(String email, String password) async {
    try {
      final response = await post('/login', {
        'email': email,
        'password': password,
      });

      // Check the entire response
      print('Login response: $response');

      // Extract the body from the response
      final responseBody = json.decode(response['body']) as Map<String, dynamic>;

      // Check if the response body contains a token
      if (responseBody.containsKey('token')) {
        String token = responseBody['token'];
        await TokenService.saveToken(token);
      } else {
        throw Exception('Login response did not contain a token.');
      }
    } catch (e) {
      print('UserService login error: $e');
      throw Exception('Login failed: $e');
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
    await TokenService.deleteToken();
  }
}
