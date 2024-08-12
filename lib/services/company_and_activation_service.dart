import 'base_api_service.dart';

class CompanyAndActivationService extends BaseApiService {

  Future<void> createCompany(String name, String ownerId, String iban) async {



    try {
      final response = await post('/createCompany', {
        'name': name,
        'ownerId': ownerId,
        'iban': iban
      });

      if (response['statusCode'] == 202) {

        return;
      } else {

        throw Exception('Failed to create company: ${response['body']}');
      }
    } catch (e) {
      print('UserService create company hata: $e');
      throw Exception('Create company başarısız: $e');
    }

  }

  Future<void> createActivation(String ownerId ,String companyId,String tcNo ,String vergiNo) async {



    try {
      final response = await post('/createActivation', {
        'ownerId': ownerId,
        'companyId': companyId,
        'tcNo': tcNo,
        'vergiNo': vergiNo
      });

      if (response['statusCode'] == 203) {
        return;
      } else {

        throw Exception('Failed to create activation: ${response['body']}');
      }
    } catch (e) {
      print('UserService create activation hata: $e');
      throw Exception('Create activation başarısız: $e');
    }

  }

  Future<dynamic> checkActiveStatus(String companyId) async {



    try {
      final response = await post('/checkActiveStatus', {
        'companyId': companyId
      });

      if (response['statusCode'] == 204) {
        return response['body'];
      } else {

        throw Exception('Failed to check status: ${response['body']}');
      }
    } catch (e) {
      print('UserService check status hata: $e');
      throw Exception('Check status başarısız: $e');
    }


  }

  Future<dynamic> getCompany(String ownerId) async {



    try {
      final response = await post('/getCompany', {
        'ownerId': ownerId
      });

      if (response['statusCode'] == 200) {
        return response['body'];
      } else {

        throw Exception('Failed to get company: ${response['body']}');
      }
    } catch (e) {
      print('UserService get company hata: $e');
      throw Exception('Get company başarısız: $e');
    }

  }

  Future<dynamic> getActivation(String companyId) async {



    try {
      final response = await post('/getActivation', {
        'companyId': companyId
      });

      if (response['statusCode'] == 200) {
        return response['body'];
      } else {

        throw Exception('Failed to get company: ${response['body']}');
      }
    } catch (e) {
      print('UserService get activation hata: $e');
      throw Exception('Get activation başarısız: $e');
    }

  }

  Future<dynamic> deleteActivation(String ownerId) async {



    try {
      final response = await post('/deleteActivation', {
        'ownerId': ownerId
      });

      if (response['statusCode'] == 200) {
        return response['body'];
      } else {

        throw Exception('Failed to delete activation: ${response['body']}');
      }
    } catch (e) {
      print('UserService delete activation hata: $e');
      throw Exception('Delete activation başarısız: $e');
    }

  }
  Future<dynamic> deleteCompany(String ownerId) async {



    try {
      final response = await post('/deleteCompany', {
        'ownerId': ownerId
      });

      if (response['statusCode'] == 200) {
        return response['body'];
      } else {

        throw Exception('Failed to delete company: ${response['body']}');
      }
    } catch (e) {
      print('UserService delete company hata: $e');
      throw Exception('Delete company başarısız: $e');
    }

  }

  Future<dynamic> getUsersAdmin(String adminId) async {



    try {
      final response = await post('/getUsersAdmin', {
        'adminId': adminId
      });

      if (response['statusCode'] == 200) {
        return response['body'];
      } else {

        throw Exception('Failed to get company: ${response['body']}');
      }
    } catch (e) {
      print('UserService get company hata: $e');
      throw Exception('Get company başarısız: $e');
    }

  }

}