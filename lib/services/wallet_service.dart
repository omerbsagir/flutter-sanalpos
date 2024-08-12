
import 'base_api_service.dart';


class WalletService extends BaseApiService {


  Future<void> createWallet(String ownerId , String companyId , String iban) async {
    try {
      final response = await post('/createWallet', {
        'ownerId': ownerId,
        'companyId': companyId,
        'iban': iban,
      });


      if (response['statusCode'] == 201) {

        return;
      } else {

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


      if (response['statusCode'] == 200) {

        return;
      } else {

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


      if (response['statusCode'] == 200) {
        return response['body'];
      } else {

        throw Exception('Failed to get wallet: ${response['body']}');
      }
    } catch (e) {
      print('WalletService get wallet hata: $e');
      throw Exception('Get Wallet başarısız: $e');
    }
  }

  Future<dynamic> deleteWallet(String ownerId) async {
    try {
      final response = await post('/deleteWallet', {
        'ownerId': ownerId
      });


      if (response['statusCode'] == 200) {
        return response['body'];
      } else {

        throw Exception('Failed to delete wallet: ${response['body']}');
      }
    } catch (e) {
      print('WalletService delete wallet hata: $e');
      throw Exception('Delete Wallet başarısız: $e');
    }
  }


}
