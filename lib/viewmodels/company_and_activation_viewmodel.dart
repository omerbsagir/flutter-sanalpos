import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/company_and_activation_repository.dart';
import '../data/remote/response/api_response.dart';

class CompanyAndActivationViewModel extends ChangeNotifier {
  final CompanyAndActivationRepository _companyAndActivationRepository = CompanyAndActivationRepository();
  ApiResponse<String> company_and_activationResponse = ApiResponse.loading();


  dynamic? checkActiveResponseValue;

  dynamic? get checkActiveResponseValueFonk => checkActiveResponseValue; //getter

  Future<dynamic> createCompany(String name, String ownerId, String iban) async {
    try {
      company_and_activationResponse = ApiResponse.loading();
      notifyListeners();

      await _companyAndActivationRepository.createCompany(name,ownerId,iban);

      company_and_activationResponse = ApiResponse.completed('Login successful');
    } catch (e) {
      print('Hata yakalandı: $e');
      company_and_activationResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners(); // UI'yi son durumu göstermek için güncelle
      return company_and_activationResponse;
    }
  }
  Future<dynamic> createActivation(String ownerId ,String companyId,String tcNo ,String vergiNo) async {
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
  Future<dynamic> checkActiveStatus(String companyId) async {
    try {
      company_and_activationResponse = ApiResponse.loading();
      notifyListeners();

      final response = await _companyAndActivationRepository.checkActiveStatus(companyId);

      print("asdasd{$response}");
      final decodedBody = json.decode(response) as Map<String, dynamic>;
      checkActiveResponseValue = decodedBody["isActive"];
      print("asd{$checkActiveResponseValue}");
      company_and_activationResponse = ApiResponse.completed('Durum kontrolü başarılı');
    } catch (e) {
      print('Hata yakalandı: $e');
      company_and_activationResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners(); // UI'yi son durumu göstermek için güncelle
      return company_and_activationResponse;
    }
  }


}
