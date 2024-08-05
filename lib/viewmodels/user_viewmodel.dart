import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../data/remote/response/api_response.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  ApiResponse<String> userResponse = ApiResponse.loading();

  Future<dynamic> login(String email , String password) async {
    try {
      userResponse = ApiResponse.loading();
      notifyListeners();

      await _userRepository.login(email,password);

      userResponse = ApiResponse.completed('Login successful');
    } catch (e) {
      print('Hata yakalandı: $e');
      userResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners(); // UI'yi son durumu göstermek için güncelle
      return userResponse;
    }
  }

  Future<dynamic> register(UserModel newUser) async {
    try {
      userResponse = ApiResponse.loading();
      notifyListeners();

      await _userRepository.register(newUser);

      userResponse = ApiResponse.completed('Registration successful');
    } catch (e) {
      print('Hata yakalandı: $e');
      userResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners(); // UI'yi son durumu göstermek için güncelle
      return userResponse;
    }
  }
  Future<dynamic> registerNewUser(String email, String phone, String password, String adminId) async {
    try {
      userResponse = ApiResponse.loading();
      notifyListeners();

      await _userRepository.registerNewUser(email,phone,password,adminId);

      userResponse = ApiResponse.completed('Registration successful');
    } catch (e) {
      print('Hata yakalandı: $e');
      userResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners(); // UI'yi son durumu göstermek için güncelle
      return userResponse;
    }
  }

}
