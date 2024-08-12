import 'dart:convert';
import 'package:flutter/material.dart';
import '../repositories/payment_repository.dart';
import '../data/remote/response/api_response.dart';
import '../viewmodels/user_viewmodel.dart';
import '../viewmodels/company_and_activation_viewmodel.dart';
import '../viewmodels/wallet_viewmodel.dart';

class PaymentViewModel extends ChangeNotifier {

  final PaymentRepository _paymentRepository = PaymentRepository();

  ApiResponse<String> _paymentResponse = ApiResponse.loading();
  UserViewModel _userViewModel = UserViewModel();
  WalletViewModel _walletViewModel = WalletViewModel();
  CompanyAndActivationViewModel _companyAndActivationViewModel = CompanyAndActivationViewModel();
  ApiResponse get paymentResponse => _paymentResponse;

  List<dynamic> TransactionDetails = [];
  String transactionId='';
  bool isTransactionsLoaded = false;



  Future<dynamic> getTransactions() async {

    //wallet Id al
    String walletId = '';
    try{
      await _walletViewModel.getWallet();
      walletId = _walletViewModel.walletId;
    }catch(e){
      print(e);
    }

    try {
      _paymentResponse = ApiResponse.loading();
      notifyListeners();

      final response = await _paymentRepository.getTransactions(walletId);
      final decodedBody = json.decode(response) as List<dynamic>;

      if (decodedBody.isNotEmpty) {
        final firstItem = decodedBody[0] as Map<String,dynamic>;
        TransactionDetails = [
          firstItem['transactionId'],
          firstItem['date'],
          firstItem['amount']
        ];
        transactionId = firstItem['transactionId'];
        isTransactionsLoaded = true;
      } else {
        transactionId = '';
        isTransactionsLoaded = false;
      }

      _paymentResponse = ApiResponse.completed('Durum kontrolü başarılı');
    } catch (e) {
      print('Hata yakalandı: $e');
      _paymentResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners();
      return _paymentResponse;
    }
  }


}
