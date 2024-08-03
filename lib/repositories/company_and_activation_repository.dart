import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterprojects/models/user_model.dart';
import '/services/company_and_activation_service.dart';

class CompanyAndActivationRepository {
  final CompanyAndActivationService _companyAndActivationService = CompanyAndActivationService();

  Future<void> createCompany(String name ,String ownerId, String iban) async {
    try {
      await _companyAndActivationService.createCompany(name,ownerId, iban);
    } catch (e) {
      print('Hata: $e');
      throw e;
    }
  }
  Future<void> createActivation(String ownerId ,String companyId,String tcNo ,String vergiNo) async {
    try {
      await _companyAndActivationService.createActivation(ownerId,companyId, tcNo,vergiNo);
    } catch (e) {
      print('Hata: $e');
      throw e;
    }
  }

}