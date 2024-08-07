import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterprojects/services/token_service.dart';
import '../models/company_model.dart';
import '../repositories/wallet_repository.dart';
import '../data/remote/response/api_response.dart';
import '../viewmodels/user_viewmodel.dart';
import '../viewmodels/company_and_activation_viewmodel.dart';

class CompanyAndActivationViewModel extends ChangeNotifier {

  final WalletRepository _walletRepository = WalletRepository();

  ApiResponse<String> _walletResponse = ApiResponse.loading();
  UserViewModel _userViewModel = UserViewModel();
  CompanyAndActivationViewModel _companyAndActivationViewModel = CompanyAndActivationViewModel();


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
      iban = await _companyAndActivationViewModel.g();
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

  Future<dynamic> updateWallet(String tcNo ,String vergiNo) async {

    String ownerId = '';
    try{
      ownerId = await _userViewModel.getUserIdFromToken();
    }catch(e){
      print(e);
    }

    String companyId = '';
    try{
      companyId = await getCompanyId();
    }catch(e){
      print(e);
    }

    try {
      company_and_activationResponse = ApiResponse.loading();
      notifyListeners();

      await _companyAndActivationRepository.createActivation(ownerId,companyId, tcNo,vergiNo);

      company_and_activationResponse = ApiResponse.completed('Login successful');
    } catch (e) {
      print('Hata yakalandı: $e');
      company_and_activationResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners(); // UI'yi son durumu göstermek için güncelle
      return company_and_activationResponse;
    }
  }

  Future<String> getCompanyId() async {

    String userId='';
    try {
      userId = await _userViewModel.getUserIdFromToken();

    } catch (e) {
      print('Error accessing protected endpoint: $e');
    }

    await getCompany();

    return companyId;
  }





}
