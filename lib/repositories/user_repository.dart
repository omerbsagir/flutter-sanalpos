import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterprojects/models/user_model.dart';
import '/services/user_service.dart';

class UserRepository {
  final UserService _userService = UserService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();


  Future<void> login(String email , String password) async {
    try {
      await _userService.login(email, password);
    } catch (e) {
      print('Hata: $e');
      throw e;
    }
  }

  Future<void> register(UserModel user) async {
    try {
      await _userService.register(user.email, user.phone, user.password);
    } catch (e) {
      print('Hata: $e');
      throw e;
    }
  }

  Future<void> logout() async {
    await _userService.logout();
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}
