import 'dart:convert';
import 'base_api_service.dart';
import 'token_service.dart';

class WalletService extends BaseApiService {

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
  Future<void> createWallet(String ownerId , String companyId , String iban) async {
    try {
      final response = await post('/createWallet', {
        'ownerId': ownerId,
        'companyId': companyId,
        'iban': iban,
      });

      // Yanıtın içeriğini kontrol et
      if (response['statusCode'] == 201) {
        // Kayıt başarılı
        return;
      } else {
        // Hata mesajını yanıt gövdesinden al
        throw Exception('Failed to create wallet: ${response['body']}');
      }
    } catch (e) {
      print('UserService create wallet hata: $e');
      throw Exception('Create Wallet başarısız: $e');
    }
  }

  Future<void> updateWallet(String walletId) async {
    try {
      final response = await post('/createWallet', {
        'walletId': walletId
      });

      // Yanıtın içeriğini kontrol et
      if (response['statusCode'] == 200) {
        // Kayıt başarılı
        return;
      } else {
        // Hata mesajını yanıt gövdesinden al
        throw Exception('Failed to update wallet: ${response['body']}');
      }
    } catch (e) {
      print('UserService update wallet hata: $e');
      throw Exception('Update Wallet başarısız: $e');
    }
  }


}
