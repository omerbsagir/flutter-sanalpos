import '/services/payment_service.dart';

class PaymentRepository {
  final PaymentService _paymentService = PaymentService();

  Future<dynamic> getTransactions(String walletId) async {
    try {
      final response = await _paymentService.getTransactions(walletId);
      return response;
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }

  Future<dynamic> createTransactions(String walletId,String amount) async {
    try {
      final response = await _paymentService.createTransactions(walletId,amount);
      return response;
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }





}
