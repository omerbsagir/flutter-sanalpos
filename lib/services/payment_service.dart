
import 'base_api_service.dart';


class PaymentService extends BaseApiService {


  Future<dynamic> getTransactions(String walletId) async {
    try {
      final response = await post('/getTransactions', {
        'walletId': walletId
      });


      if (response['statusCode'] == 200) {
        return response['body'];
      } else {

        throw Exception('Failed to get transactions: ${response['body']}');
      }
    } catch (e) {
      print('WalletService get transactions hata: $e');
      throw Exception('Get Transactions başarısız: $e');
    }
  }

  Future<dynamic> createTransactions(String walletId , String amount) async {
    try {
      final response = await post('/createTransaction', {
        'walletId': walletId ,
        'amount' : amount
      });


      if (response['statusCode'] == 200) {
        return response['body'];
      } else {

        throw Exception('Failed to create transactions: ${response['body']}');
      }
    } catch (e) {
      print('WalletService create transactions hata: $e');
      throw Exception('Create Transactions başarısız: $e');
    }
  }


}
