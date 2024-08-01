import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '/services/user_service.dart';

class UserRepository {
  final UserService _userService = UserService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> login(String email, String password) async {
    await _userService.login(email, password);
  }

  Future<void> register(String email, String phone, String password) async {
    await _userService.register(email, phone, password);
  }

  Future<void> logout() async {
    await _userService.logout();
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}
