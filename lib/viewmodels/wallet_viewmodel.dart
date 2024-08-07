import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterprojects/services/token_service.dart';
import '../models/company_model.dart';
import '../repositories/wallet_repository.dart';
import '../data/remote/response/api_response.dart';
import '../viewmodels/user_viewmodel.dart';
import '../viewmodels/company_and_activation_viewmodel.dart';

class WalletViewModel extends ChangeNotifier {

  final WalletRepository _walletRepository = WalletRepository();

  ApiResponse<String> _walletResponse = ApiResponse.loading();
  UserViewModel _userViewModel = UserViewModel();
  CompanyAndActivationViewModel _companyAndActivationViewModel = CompanyAndActivationViewModel();
  ApiResponse get walletResponse => _walletResponse;

  List<dynamic> walletDetails = [];
  String walletId='';
  bool isWalletLoaded = false;

  dynamic? checkActiveResponseValue;
  dynamic? get walletDetailsFonk => walletDetails; //getter

  Future<dynamic> createWallet() async {
    String ownerId = '';
    try{
      ownerId = await _userViewModel.getUserIdFromToken();
    }catch(e){
      print(e);
    }
    String companyId = '';
    try{
      companyId = await _companyAndActivationViewModel.getCompanyId();
    }catch(e){
      print(e);
    }
    String iban = '';
    try{
      iban = await _companyAndActivationViewModel.getIban();
    }catch(e){
      print(e);
    }

    try {
      _walletResponse = ApiResponse.loading();
      notifyListeners();

      await _walletRepository.createWallet(ownerId,companyId,iban);

      _walletResponse = ApiResponse.completed('Login successful');
    } catch (e) {
      print('Hata yakalandı: $e');
      _walletResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners(); // UI'yi son durumu göstermek için güncelle
      return _walletResponse;
    }
  }

  Future<dynamic> updateWallet() async {

    try{
      await getWallet();
    }catch(e){
      print(e);
    }

    try {
      _walletResponse = ApiResponse.loading();
      notifyListeners();

      await _walletRepository.updateWallet(walletId);

      _walletResponse = ApiResponse.completed('Update Successful');
    } catch (e) {
      print('Hata yakalandı: $e');
      _walletResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners(); // UI'yi son durumu göstermek için güncelle
      return _walletResponse;
    }
  }

  Future<dynamic> getWallet() async {
    String ownerId = '';
    try{
      ownerId = await _userViewModel.getUserIdFromToken();
    }catch(e){
      print(e);
    }

    try {
      _walletResponse = ApiResponse.loading();
      notifyListeners();

      final response = await _walletRepository.getWallet(ownerId);
      final decodedBody = json.decode(response) as List<dynamic>;

      if (decodedBody.isNotEmpty) {
        final firstItem = decodedBody[0] as Map<String,dynamic>;
        walletDetails = [
          firstItem['iban'],
          firstItem['amount'].toString()
        ];
        walletId = firstItem['walletId'];
        isWalletLoaded = true; // Şirket bilgileri yüklendi
      } else {
        walletId = '';
        isWalletLoaded = false; // Şirket bilgileri bulunamadı
      }

      _walletResponse = ApiResponse.completed('Durum kontrolü başarılı');
    } catch (e) {
      print('Hata yakalandı: $e');
      _walletResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners(); // UI'yi son durumu göstermek için güncelle
      return _walletResponse;
    }
  }





}
