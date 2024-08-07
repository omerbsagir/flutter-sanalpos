import 'dart:convert';
import 'base_api_service.dart';
import 'token_service.dart';

class WalletService extends BaseApiService {

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
      print('WalletService create wallet hata: $e');
      throw Exception('Create Wallet başarısız: $e');
    }
  }

  Future<void> updateWallet(String walletId) async {
    try {
      final response = await post('/updateWallet', {
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
      print('WalletService update wallet hata: $e');
      throw Exception('Update Wallet başarısız: $e');
    }
  }

  Future<dynamic> getWallet(String ownerId) async {
    try {
      final response = await post('/getWallet', {
        'ownerId': ownerId
      });

      // Yanıtın içeriğini kontrol et
      if (response['statusCode'] == 200) {
        return response['body'];
      } else {
        // Hata mesajını yanıt gövdesinden al
        throw Exception('Failed to get wallet: ${response['body']}');
      }
    } catch (e) {
      print('WalletService get wallet hata: $e');
      throw Exception('Get Wallet başarısız: $e');
    }
  }


}
