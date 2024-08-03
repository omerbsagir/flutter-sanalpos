import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterprojects/repositories/user_repository.dart';
import 'base_api_service.dart';

class CompanyAndActivationService extends BaseApiService {

  final UserRepository _userRepository = new UserRepository();

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

}