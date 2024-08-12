
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


}
