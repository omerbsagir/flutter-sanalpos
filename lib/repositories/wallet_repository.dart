import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterprojects/models/user_model.dart';
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
  



}
