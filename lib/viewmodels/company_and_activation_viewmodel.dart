import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/company_model.dart';
import '../repositories/company_and_activation_repository.dart';
import '../data/remote/response/api_response.dart';

class CompanyAndActivationViewModel extends ChangeNotifier {
  final CompanyAndActivationRepository _companyAndActivationRepository = CompanyAndActivationRepository();
  ApiResponse<String> company_and_activationResponse = ApiResponse.loading();

  List<dynamic> companyDetails = [];
  List<dynamic> usersForAdmin = [];

  dynamic? checkActiveResponseValue;
  dynamic? get checkActiveResponseValueFonk => checkActiveResponseValue; //getter
  dynamic? get companyDetailsFonk => companyDetails; //getter

  bool isCompanyLoaded = false;
  bool isUsersLoaded = false;

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

      final decodedBody = json.decode(response) as Map<String, dynamic>;
      checkActiveResponseValue = decodedBody["isActive"];

      company_and_activationResponse = ApiResponse.completed('Durum kontrolü başarılı');
    } catch (e) {
      print('Hata yakalandı: $e');
      company_and_activationResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners(); // UI'yi son durumu göstermek için güncelle
      return company_and_activationResponse;
    }
  }
  Future<dynamic> getCompany(String ownerId) async {
    try {
      company_and_activationResponse = ApiResponse.loading();
      notifyListeners();

      final response = await _companyAndActivationRepository.getCompany(ownerId);
      final decodedBody = json.decode(response) as List<dynamic>;

      if (decodedBody.isNotEmpty) {
        final firstItem = decodedBody[0] as Map<String, dynamic>;
        companyDetails = [
          firstItem['name'],
          firstItem['iban'],
          firstItem['activationStatus']
        ];
        isCompanyLoaded = true; // Şirket bilgileri yüklendi
      } else {
        companyDetails = [];
        isCompanyLoaded = false; // Şirket bilgileri bulunamadı
      }

      company_and_activationResponse = ApiResponse.completed('Durum kontrolü başarılı');
    } catch (e) {
      print('Hata yakalandı: $e');
      company_and_activationResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners(); // UI'yi son durumu göstermek için güncelle
      return company_and_activationResponse;
    }
  }
  Future<dynamic> getUsersAdmin(String adminId) async {
    try {
      company_and_activationResponse = ApiResponse.loading();
      notifyListeners();

      final response = await _companyAndActivationRepository.getUsersAdmin(adminId);
      final decodedBody = json.decode(response) as List<dynamic>;

      if (decodedBody.isNotEmpty) {
        for(int i=0;i<decodedBody.length;i++){
          final listItem = decodedBody[i] as Map<String, dynamic>;
          usersForAdmin.add(listItem['email']);
        }
        isUsersLoaded = true; // Şirket bilgileri yüklendi
      } else {
        usersForAdmin = [];
        isUsersLoaded = false; // Şirket bilgileri bulunamadı
      }

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
