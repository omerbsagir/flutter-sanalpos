
import '/services/company_and_activation_service.dart';

class CompanyAndActivationRepository {
  final CompanyAndActivationService _companyAndActivationService = CompanyAndActivationService();

  Future<void> createCompany(String name ,String ownerId, String iban) async {
    try {
      await _companyAndActivationService.createCompany(name,ownerId, iban);
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }
  Future<void> createActivation(String ownerId ,String companyId,String tcNo ,String vergiNo) async {
    try {
      await _companyAndActivationService.createActivation(ownerId,companyId, tcNo,vergiNo);
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }
  Future<dynamic> checkActiveStatus(String companyId) async {
    try {
      final response = await _companyAndActivationService.checkActiveStatus(companyId);

      return response;
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }
  Future<dynamic> getCompany(String ownerId) async {
    try {
      final response = await _companyAndActivationService.getCompany(ownerId);
      return response;
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }
  Future<dynamic> getActivation(String companyId) async {
    try {
      final response = await _companyAndActivationService.getActivation(companyId);
      return response;
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }
  Future<dynamic> deleteActivation(String ownerId) async {
    try {
      final response = await _companyAndActivationService.deleteActivation(ownerId);
      return response;
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }
  Future<dynamic> deleteCompany(String ownerId) async {
    try {
      final response = await _companyAndActivationService.deleteCompany(ownerId);
      return response;
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }
  Future<dynamic> getUsersAdmin(String adminId) async {
    try {
      final response = await _companyAndActivationService.getUsersAdmin(adminId);
      return response;
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }

}