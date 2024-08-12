import '/services/wallet_service.dart';

class WalletRepository {
  final WalletService _walletService = WalletService();

  Future<void> createWallet(String ownerId , String companyId , String iban) async {
    try {
      await _walletService.createWallet(ownerId, companyId,iban);
    } catch (e) {
      print('Hata: $e');
      throw e;
    }
  }

  Future<void> updateWallet(String walletId) async {
    try {
      await _walletService.updateWallet(walletId);
    } catch (e) {
      print('Hata: $e');
      throw e;
    }
  }

  Future<dynamic> getWallet(String ownerId) async {
    try {
      final response = await _walletService.getWallet(ownerId);
      return response;
    } catch (e) {
      print('Hata: $e');
      throw e;
    }
  }
  Future<dynamic> deleteWallet(String ownerId) async {
    try {
      final response = await _walletService.deleteWallet(ownerId);
      return response;
    } catch (e) {
      print('Hata: $e');
      throw e;
    }
  }




}
