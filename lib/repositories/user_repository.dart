import '../services/base_api_service.dart';
import '../models/user_model.dart';

class UserRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<UserModel> login(String email, String password) async {
    final response = await _apiService.post(
      'https://yourapiurl.com/login',
      {'email': email, 'password': password},
    );
    return UserModel.fromJson(response);
  }

  Future<UserModel> register(String name, String email, String password) async {
    final response = await _apiService.post(
      'https://yourapiurl.com/register',
      {'name': name, 'email': email, 'password': password},
    );
    return UserModel.fromJson(response);
  }
}
