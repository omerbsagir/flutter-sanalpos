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
  Future<void> registerNewUser(String email, String phone, String password, String adminId) async {
    try {
      await _userService.registerNewUser(email, phone, password,adminId);
    } catch (e) {
      print('Hata: $e');
      throw e;
    }
  }
  Future<void> protected(String token) async {
    try {
      await _userService.protected(token);
    } catch (e) {
      print('Hata: $e');
      throw e;
    }
  }


}
