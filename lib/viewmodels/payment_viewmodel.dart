import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterprojects/models/transactions_model.dart';
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

  List<TransactionModel> TransactionDetails = [];
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

      TransactionDetails = decodedBody.map((json) => TransactionModel.fromJson(json)).toList();
      isTransactionsLoaded = TransactionDetails.isNotEmpty;


      _paymentResponse = ApiResponse.completed('Durum kontrolü başarılı');
    } catch (e) {
      print('Hata yakalandı: $e');
      _paymentResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners();
      return _paymentResponse;
    }
  }

  Future<dynamic> createTransactions(String amount) async {

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

      final response = await _paymentRepository.createTransactions(walletId,amount);
      final decodedBody = json.decode(response) as List<dynamic>;

      TransactionDetails = decodedBody.map((json) => TransactionModel.fromJson(json)).toList();
      isTransactionsLoaded = TransactionDetails.isNotEmpty;


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
