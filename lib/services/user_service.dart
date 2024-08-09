import 'dart:convert';
import 'base_api_service.dart';
import 'token_service.dart';

class UserService extends BaseApiService {

  Future<void> login(String email, String password) async {
    try {
      final response = await post('/login', {
        'email': email,
        'password': password,
      });


      print('Login response: $response');


      final responseBody = json.decode(response['body']) as Map<String, dynamic>;


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

  Future<void> register(String email, String phone, String password) async {
    try {
      final response = await post('/register', {
        'email': email,
        'phone': phone,
        'password': password,
      });

      if (response['statusCode'] == 201) {

        return;
      } else {

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


      if (response['statusCode'] == 201) {

        return;
      } else {

        throw Exception('Failed to register: ${response['body']}');
      }
    } catch (e) {
      print('UserService register hata: $e');
      throw Exception('Kayıt başarısız: $e');
    }
  }

  Future<void> logout() async {
    await TokenService.deleteToken();
  }

  Future<bool> validateToken(String token) async {

    try{
      final response = await post('/validateToken', {
        'token' : token,
      });
      if(response['statusCode'] == 200){
        print('Token is valid');
        return true;
      }else if(response['statusCode'] == 401){
        print('Token is invalid');
        return false;
      }else{
        throw Exception('Token required!');
      }

    }catch(e){
      print('UserService token validation hata: $e');
      throw Exception('Error token validation: $e');
    }

  }

  Future<dynamic> getUsersForUserRole(String userId) async {



    try {
      final response = await post('/getUser', {
        'userId': userId
      });

      if (response['statusCode'] == 200) {
        return response['body'];
      } else {

        throw Exception('Failed to get user: ${response['body']}');
      }
    } catch (e) {
      print('UserService get user hata: $e');
      throw Exception('Get user başarısız: $e');
    }

  }

}
