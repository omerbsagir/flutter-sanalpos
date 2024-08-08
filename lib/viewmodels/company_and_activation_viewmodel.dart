import 'dart:convert';
import 'package:flutter/material.dart';
import '../repositories/company_and_activation_repository.dart';
import '../data/remote/response/api_response.dart';
import '../viewmodels/user_viewmodel.dart';

class CompanyAndActivationViewModel extends ChangeNotifier {

  final CompanyAndActivationRepository _companyAndActivationRepository = CompanyAndActivationRepository();
  ApiResponse<String> company_and_activationResponse = ApiResponse.loading();
  UserViewModel _userViewModel = UserViewModel();

  String companyId='';
  String iban='';
  List<dynamic> companyDetails = [];
  List<dynamic> usersForAdmin = [];

  dynamic? checkActiveResponseValue;
  dynamic? get checkActiveResponseValueFonk => checkActiveResponseValue; //getter
  dynamic? get companyDetailsFonk => companyDetails; //getter

  bool isCompanyLoaded = false;
  bool isUsersLoaded = false;

  Future<dynamic> createCompany(String name, String iban) async {
    String ownerId = '';
    try{
      ownerId = await _userViewModel.getUserIdFromToken();
    }catch(e){
      print(e);
    }

    try {
      company_and_activationResponse = ApiResponse.loading();
      notifyListeners();

      await _companyAndActivationRepository.createCompany(name,ownerId,iban);

      company_and_activationResponse = ApiResponse.completed('Login successful');
    } catch (e) {
      print('Hata yakalandı: $e');
      company_and_activationResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners();
      return company_and_activationResponse;
    }
  }
  Future<dynamic> createActivation(String tcNo ,String vergiNo) async {

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
      notifyListeners();
      return company_and_activationResponse;
    }
  }
  Future<dynamic> checkActiveStatus() async {

    String companyId = '';
    try{
      companyId = await getCompanyId();
    }catch(e){
      print(e);
    }
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
      notifyListeners();
      return company_and_activationResponse;
    }
  }
  Future<dynamic> getCompany() async {
    String ownerId = '';
    try{
      ownerId = await _userViewModel.getUserIdFromToken();
    }catch(e){
      print(e);
    }

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
        companyId = firstItem['companyId'];
        iban = firstItem['iban'];
        isCompanyLoaded = true;
      } else {
        companyDetails = [];
        isCompanyLoaded = false;
      }

      company_and_activationResponse = ApiResponse.completed('Durum kontrolü başarılı');
    } catch (e) {
      print('Hata yakalandı: $e');
      company_and_activationResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners();
      return company_and_activationResponse;
    }
  }
  Future<dynamic> getUsersAdmin() async {

    String adminId = '';
    try{
      adminId = await _userViewModel.getUserIdFromToken();
    }catch(e){
      print(e);
    }

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
        isUsersLoaded = true;
      } else {
        usersForAdmin = [];
        isUsersLoaded = false;
      }

      company_and_activationResponse = ApiResponse.completed('Durum kontrolü başarılı');
    } catch (e) {
      print('Hata yakalandı: $e');
      company_and_activationResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners();
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
  Future<String> getIban() async {

    String userId='';
    try {
      userId = await _userViewModel.getUserIdFromToken();

    } catch (e) {
      print('Error accessing protected endpoint: $e');
    }

    await getCompany();

    return iban;
  }





}
