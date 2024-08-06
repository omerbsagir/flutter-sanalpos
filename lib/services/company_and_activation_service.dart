import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterprojects/repositories/user_repository.dart';
import 'base_api_service.dart';

class CompanyAndActivationService extends BaseApiService {

  //final UserRepository _userRepository = new UserRepository();

  // User login
  Future<void> createCompany(String name, String ownerId, String iban) async {

    // const string ownerId = returnOwnerId();

    try {
      final response = await post('/createCompany', {
        'name': name,
        'ownerId': ownerId,
        'iban': iban
      });

      // Yanıtın içeriğini kontrol et
      if (response['statusCode'] == 202) {

        return;
      } else {
        // Hata mesajını yanıt gövdesinden al
        throw Exception('Failed to create company: ${response['body']}');
      }
    } catch (e) {
      print('UserService create company hata: $e');
      throw Exception('Create company başarısız: $e');
    }

  }

  Future<void> createActivation(String ownerId ,String companyId,String tcNo ,String vergiNo) async {

    // const string ownerId = returnOwnerId();
    // const string companyId = returnCompanyId();

    try {
      final response = await post('/createActivation', {
        'ownerId': ownerId,
        'companyId': companyId,
        'tcNo': tcNo,
        'vergiNo': vergiNo
      });

      // Yanıtın içeriğini kontrol et
      if (response['statusCode'] == 203) {
        return;
      } else {
        // Hata mesajını yanıt gövdesinden al
        throw Exception('Failed to create activation: ${response['body']}');
      }
    } catch (e) {
      print('UserService create activation hata: $e');
      throw Exception('Create activation başarısız: $e');
    }

  }

  Future<dynamic> checkActiveStatus(String companyId) async {

    // const string companyId = returnCompanyId();

    try {
      final response = await post('/checkActiveStatus', {
        'companyId': companyId
      });
      // Yanıtın içeriğini kontrol et
      if (response['statusCode'] == 204) {
        return response['body'];
      } else {
        // Hata mesajını yanıt gövdesinden al
        throw Exception('Failed to check status: ${response['body']}');
      }
    } catch (e) {
      print('UserService check status hata: $e');
      throw Exception('Check status başarısız: $e');
    }


  }

  Future<dynamic> getCompany(String ownerId) async {

    // const string ownerId = returnCompanyId();

    try {
      final response = await post('/getCompany', {
        'ownerId': ownerId
      });
      // Yanıtın içeriğini kontrol et
      if (response['statusCode'] == 200) {
        return response['body'];
      } else {
        // Hata mesajını yanıt gövdesinden al
        throw Exception('Failed to get company: ${response['body']}');
      }
    } catch (e) {
      print('UserService get company hata: $e');
      throw Exception('Get company başarısız: $e');
    }

  }

  Future<dynamic> getUsersAdmin(String adminId) async {

    // const string adminId = returnAdminId();

    try {
      final response = await post('/getUsersAdmin', {
        'adminId': adminId
      });
      // Yanıtın içeriğini kontrol et
      if (response['statusCode'] == 200) {
        return response['body'];
      } else {
        // Hata mesajını yanıt gövdesinden al
        throw Exception('Failed to get company: ${response['body']}');
      }
    } catch (e) {
      print('UserService get company hata: $e');
      throw Exception('Get company başarısız: $e');
    }

  }

}