import 'package:e_pos/models/user_model.dart';
import '/services/user_service.dart';

class UserRepository {
  final UserService _userService = UserService();



  Future<void> login(String email , String password) async {
    try {
      await _userService.login(email, password);
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }

  Future<void> register(UserModel user) async {
    try {
      await _userService.register(user.email, user.phone, user.password);
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }
  Future<void> registerNewUser(UserModel user , String adminId) async {
    try {
      await _userService.registerNewUser(user.email, user.phone, user.password,adminId);
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }
  Future<void> logout() async {
    try {
      await _userService.logout();
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }

  Future<dynamic> getUser(String userId) async {
    try {
      final response = await _userService.getUser(userId);
      return response;
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }
  Future<dynamic> deleteUser(String email) async {
    try {
      final response = await _userService.deleteUser(email);
      return response;
    } catch (e) {
      print('Hata: $e');
      rethrow;
    }
  }

}
